# == Auditable
#
# Provides a standardized way to track changes (creation, update, deletion)
# to ActiveRecord models and their associated records, logging these changes
# to an +AuditLog+ model.
#
# The primary goal is to create a clear, historical record of modifications
# made to key data within the application. By including this concern in a model,
# developers can easily enable auditing for that model and specify which
# attributes and associations are relevant for tracking.
module Auditable
  extend ActiveSupport::Concern

  included do
    # Class attribute to store the raw auditable configuration (only/except options).
    class_attribute :_auditable_raw_config, instance_accessor: false, default: nil

    # Class attribute to store the resolved auditable configuration ({ attributes: [...], associations: [...] }).
    # This is calculated lazily the first time the config is needed.
    class_attribute :_resolved_auditable_config, instance_accessor: false, default: nil

    # Temporary storage for destroyed associated records' audit info during a transaction.
    # This data is captured in a before_update callback and used in the after_commit.
    attr_accessor :_destroyed_associations_audit_data
  end

  # Temporarily suppresses audit logging within the given block.
  #
  # @yield The block of code to execute with auditing suppressed.
  def self.without_auditing
    original_suppression_state = ActiveSupport::IsolatedExecutionState[:auditing_suppressed]
    ActiveSupport::IsolatedExecutionState[:auditing_suppressed] = true
    begin
      yield
    ensure
      ActiveSupport::IsolatedExecutionState[:auditing_suppressed] = original_suppression_state
    end
  end

  # Temporarily enables audit logging within the given block.
  #
  # @yield The block of code to execute with auditing enabled.
  def self.with_auditing
    original_suppression_state = ActiveSupport::IsolatedExecutionState[:auditing_suppressed]
    ActiveSupport::IsolatedExecutionState[:auditing_suppressed] = false
    begin
      yield
    ensure
      ActiveSupport::IsolatedExecutionState[:auditing_suppressed] = original_suppression_state
    end
  end

  class_methods do
    # Configures the model to be actively auditable.
    # This method includes the +has_many :audit_logs+ association and registers
    # the necessary +before_update+ and +after_commit+ callbacks for tracking
    # create, update, and destroy events.
    #
    # @param only [Array<Symbol>, nil] An array of attribute names and association names to explicitly track.
    # @param except [Array<Symbol>, nil] An array of attribute names and association names to exclude from tracking.
    # @raise [ArgumentError] If auditable or auditable_attributes has already been called on the model.
    def auditable(only: nil, except: nil)
      raise ArgumentError, "auditable or auditable_attributes already set" if _auditable_raw_config
      self._auditable_raw_config = { only: only, except: except }

      has_many :audit_logs, as: :auditable

      before_update :capture_destroyed_associations_for_auditing
      after_commit :write_audit_log_on_create, on: :create
      after_commit :write_audit_log_on_update, on: :update
      after_commit :write_audit_log_on_destroy, on: :destroy
    end

    # Configures the model to be passively auditable, typically as an associated
    # record of a model using the +auditable+ method.
    # This method configures which of the model's attributes and associations
    # are relevant for auditing when a parent model collects changes from it.
    # It does NOT register any callbacks on this model itself.
    #
    # @param only [Array<Symbol>, nil] An array of attribute names and association names to explicitly track when audited by a parent.
    # @param except [Array<Symbol>, nil] An array of attribute names and association names to exclude from tracking when audited by a parent.
    # @raise [ArgumentError] If auditable or auditable_attributes has already been called on the model.
    def auditable_attributes(only: nil, except: nil)
      raise ArgumentError, "auditable or auditable_attributes already set" if _auditable_raw_config
      self._auditable_raw_config = { only: only, except: except }
    end

    # Lazily resolves and returns the auditable configuration.
    # This method is called the first time the configuration is accessed,
    # ensuring all associations are defined when reflect_on_all_associations is called.
    #
    # @return [Hash] A hash containing :attributes (Array<Symbol>) and :associations (Array<Symbol>) to track.
    def _get_resolved_auditable_config
      @_resolved_auditable_config ||= resolve_auditable_config(
        only: _auditable_raw_config[:only],
        except: _auditable_raw_config[:except]
      )
    end

    # Helper method to get a map of foreign key names to auditable belongs_to association names.
    # This map is used to identify belongs_to foreign key changes in previous_changes
    # and look up the corresponding association name for logging.
    # Memoized for performance.
    #
    # @return [Hash<String, String>] A hash where keys are foreign key column names (strings)
    #   and values are belongs_to association names (strings) that are configured for auditing.
    def _auditable_belongs_to_foreign_keys_map
      @_auditable_belongs_to_foreign_keys_map ||= begin
        keys = {}
        (_get_resolved_auditable_config[:associations] || []).each do |assoc_name|
          assoc = reflect_on_association(assoc_name)
          if assoc && assoc.macro == :belongs_to
            keys[assoc.foreign_key.to_s] = assoc_name.to_s
          end
        end
        keys
      end
    end

    private

    # Resolves the auditable configuration based on the provided only/except options.
    # Determines which attributes and associations should be tracked.
    #
    # @param only [Array<Symbol>, nil]
    # @param except [Array<Symbol>, nil]
    # @return [Hash] A hash containing :attributes (Array<Symbol>) and :associations (Array<Symbol>) to track.
    def resolve_auditable_config(only:, except:)
      attrs = column_names.map(&:to_sym)
      tracked =
        if only
          only.map(&:to_sym)
        elsif except
          attrs - except.map(&:to_sym)
        else
          attrs - [ :created_at, :updated_at, :id, :password_digest ]
        end

      associations = reflect_on_all_associations.map(&:name)
      {
        attributes: tracked - associations,
        associations: tracked & associations,
      }
    end
  end

  # == Instance Methods
  #
  # These methods are available on instances of models that include the Auditable concern.

  # Called by parent models to extract changes from associated records.
  # Also used internally to determine changes for the current record's audit log.
  # Determines the raw changes and fields for auditing based on the record's state.
  #
  # @return [Hash] A hash containing "audited_changes" (Hash) and "audited_fields" (Array<String>).
  #   The structure is compatible with the AuditLog model's jsonb columns.
  def audit_changes_raw
    if destroyed?
      collect_self_destruction_changes
    elsif previously_new_record?
      collect_self_creation_changes
    else
      collect_update_changes
    end
  end

  # Provides a human-readable name for the auditable record.
  # This name is used in audit log entries.
  # Can be overridden in individual models if the default is not suitable.
  #
  # @return [String] The name of the record for auditing purposes.
  def audit_name
    respond_to?(:name) ? name.to_s : "#{self.class.name}##{id}"
  end

  private

  # Collects changes specific to the destruction of the record itself.
  # Used when the record's after_commit on :destroy callback fires.
  #
  # @return [Hash] Formatted changes and fields for a destruction event.
  def collect_self_destruction_changes
    {
      "audited_changes" => { "_destroyed" => [ audit_name, nil ] },
      "audited_fields" => [ "_destroyed" ],
    }
  end

  # Collects changes specific to the creation of the record itself.
  # Used when the record's after_commit on :create callback fires.
  #
  # @return [Hash] Formatted changes and fields for a creation event.
  def collect_self_creation_changes
    {
      "audited_changes" => { "_created" => [ nil, audit_name ] },
      "audited_fields" => [ "_created" ],
    }
  end

  # Collects all changes for an updated record, including attribute and association changes.
  # Used when the record's after_commit on :update callback fires.
  #
  # @return [Hash] Merged changes and fields from attributes and associations.
  def collect_update_changes
    audited_changes = {}
    audited_fields = []

    attribute_changes, attribute_fields = collect_attribute_and_belongs_to_changes
    audited_changes.merge!(attribute_changes)
    audited_fields.concat(attribute_fields)

    assoc_changes, changed_fields = collect_association_changes
    audited_changes.merge!(assoc_changes)
    audited_fields.concat(changed_fields)

    destroyed_assoc_changes, destroyed_fields = collect_destroyed_association_changes
    audited_changes.merge!(destroyed_assoc_changes)
    audited_fields.concat(destroyed_fields)

    audited_fields.uniq!

    {
      "audited_changes" => audited_changes,
      "audited_fields" => audited_fields,
    }
  end

  # Collects changes for the record's own attributes, including special handling for belongs_to associations.
  # Iterates through previous_changes and formats attribute changes or belongs_to name changes.
  #
  # @return [Array<Hash, Array<String>>] A two-element array:
  #   [0] Hash of attribute/belongs_to changes.
  #   [1] Array of attribute/belongs_to field names.
  def collect_attribute_and_belongs_to_changes
    audited_changes = {}
    audited_fields = []
    tracked_attrs_strings = self.class._get_resolved_auditable_config[:attributes].map(&:to_s)

    previous_changes.each do |attribute, change|
      belongs_to_assoc = belongs_to_association_for_foreign_key(attribute)

      if belongs_to_assoc
        belongs_to_change_data = process_belongs_to_change(belongs_to_assoc, change)

        audited_changes.merge!(belongs_to_change_data[:changes])
        audited_fields.concat(belongs_to_change_data[:fields])
      elsif tracked_attrs_strings.include?(attribute)
         audited_changes[attribute] = change
         audited_fields << attribute
      end
    end

    [ audited_changes, audited_fields ]
  end

  # Helper method to process a change to a belongs_to foreign key.
  # Finds the old and new associated records' names and formats the change for the audit log.
  #
  # @param belongs_to_assoc [ActiveRecord::Reflection::AssociationReflection] The reflection object for the belongs_to association.
  # @param change [Array] The old and new values for the foreign key (e.g., [old_id, new_id]).
  # @return [Hash] A hash containing :changes (Hash) and :fields (Array<String>).
  #   Returns { changes: { "assoc_name" => [old_name, new_name] }, fields: ["assoc_name"] } if a significant change occurred,
  #   or { changes: {}, fields: [] } if the old and new names are the same.
  def process_belongs_to_change(belongs_to_assoc, change)
    result = { changes: {}, fields: [] }

    assoc_name = belongs_to_assoc.name.to_s

    old_id, new_id = change

    old_name = find_associated_record_name_by_id(belongs_to_assoc, old_id)
    new_name = find_associated_record_name_by_id(belongs_to_assoc, new_id)

    if old_name != new_name
       result[:changes][assoc_name] = [ old_name, new_name ]
       result[:fields] << assoc_name
    end

    result
  end

  # Helper method to find an associated record by its ID and get its audit name.
  # Handles cases where the ID is nil or the record doesn't respond to audit_name.
  #
  # @param belongs_to_assoc [ActiveRecord::Reflection::AssociationReflection] The reflection object for the belongs_to association.
  # @param id [Integer, String, nil] The ID of the associated record.
  # @return [String, nil] The audit name of the associated record, or nil if the ID is blank,
  #   the record is not found, or the record does not respond to audit_name.
  def find_associated_record_name_by_id(belongs_to_assoc, id)
    return nil unless id.present?

    record = belongs_to_assoc.klass.find_by(belongs_to_assoc.active_record_primary_key => id)
    record.try(:audit_name)
  end

  # Returns the reflection object for a belongs_to association corresponding to a given foreign key attribute.
  # Looks up the association name using the class's _auditable_belongs_to_foreign_keys_map,
  # and returns the association reflection if found, or nil otherwise.
  #
  # @param attribute [String] The name of the foreign key attribute (as a string).
  # @return [ActiveRecord::Reflection::AssociationReflection, nil] The reflection object for the belongs_to association,
  #   or nil if the attribute does not correspond to a tracked belongs_to association.
  def belongs_to_association_for_foreign_key(attribute)
    assoc_name = self.class._auditable_belongs_to_foreign_keys_map[attribute]
    assoc_name ? self.class.reflect_on_association(assoc_name.to_sym) : nil
  end

  # Callback to capture information about associated records marked for destruction
  # before they are actually destroyed in the database.
  # This information is stored temporarily and used later in the after_commit :on_update callback.
  # This method is called on the parent record's before_update callback.
  def capture_destroyed_associations_for_auditing
    self._destroyed_associations_audit_data = {}
    (self.class._get_resolved_auditable_config[:associations] || []).each do |assoc_name|
      assoc = self.class.reflect_on_association(assoc_name.to_sym)

      if assoc && (assoc.macro == :has_many || assoc.macro == :has_one) && self.respond_to?("#{assoc_name}_attributes=")
        Array(send(assoc_name).target).each do |record|
          next unless record.respond_to?(:audit_changes_raw)

          if record.persisted? && record.try(:marked_for_destruction?)
            self._destroyed_associations_audit_data[assoc_name] ||= []
            self._destroyed_associations_audit_data[assoc_name] << {
              id: record.id,
              audit_name: record.audit_name,
            }
          end
        end
      end
    end
  end

  # Writes an audit log entry for a create event.
  # Triggered by the after_commit on :create callback.
  #
  # @param action [String] The action performed ('create').
  # @param audited_changes [Hash] The changes to be logged.
  # @param audited_fields [Array<String>] The names of the fields that changed.
  def write_audit_log_on_create
    log_audit!(
      action: "create",
      audited_changes: audit_changes_raw["audited_changes"],
      audited_fields: audit_changes_raw["audited_fields"],
    )
  end

  # Writes an audit log entry for an update event.
  # Triggered by the after_commit on :update callback.
  #
  # @param action [String] The action performed ('update').
  # @param audited_changes [Hash] The changes to be logged.
  # @param audited_fields [Array<String>] The names of the fields that changed.
  def write_audit_log_on_update
    raw_changes = audit_changes_raw
    all_changes = raw_changes["audited_changes"]

    return if all_changes.empty?

    log_audit!(action: "update", audited_changes: all_changes, audited_fields: raw_changes["audited_fields"])
  end

  # Writes an audit log entry for a destroy event.
  # Triggered by the after_commit on :destroy callback.
  #
  # @param action [String] The action performed ('destroy').
  # @param audited_changes [Hash] The changes to be logged.
  # @param audited_fields [Array<String>] The names of the fields that changed.
  def write_audit_log_on_destroy
    log_audit!(
      action: "destroy",
      audited_changes: audit_changes_raw["audited_changes"],
      audited_fields: audit_changes_raw["audited_fields"],
    )
  end

  # Collects changes for associated has_many or has_one records that were created or updated.
  # This method is called by the parent record's collect_update_changes method.
  # Excludes records marked for destruction (handled separately by collect_destroyed_association_changes).
  #
  # @return [Array<Hash, Array<String>>] A two-element array:
  #   [0] Hash of associated record changes (e.g., { "association.id.attribute" => [old_value, new_value] }).
  #   [1] Array of associated record field names (e.g., ["association.attribute"]).
  def collect_association_changes
    assoc_changes = {}
    changed_fields = []

    (self.class._get_resolved_auditable_config[:associations] || []).each do |assoc_name|
      assoc = self.class.reflect_on_association(assoc_name.to_sym)
      next unless assoc && (assoc.macro == :has_many || assoc.macro == :has_one)

      records = Array(send(assoc_name).target)
      records.each do |record|
        next if record.try(:marked_for_destruction?)
        next unless record.respond_to?(:audit_changes_raw)

        raw = record.audit_changes_raw
        next if raw["audited_changes"].empty? || raw["audited_changes"].keys == [ "_destroyed" ]

        raw["audited_changes"].each do |attr, change|
          key = "#{assoc_name}.#{record.id}.#{attr}"
          assoc_changes[key] = change
        end

        raw["audited_fields"].each do |attr|
          changed_fields << "#{assoc_name}.#{attr}"
        end
      end
    end

    [ assoc_changes, changed_fields ]
  end

  # Collects changes for has_many or has_one associations that were destroyed.
  # This method uses the data captured in the before_update callback.
  #
  # @return [Array<Hash, Array<String>>] A two-element array:
  #   [0] Hash of destroyed associated record changes (e.g., { "association.id._destroyed" => ["Old Name", nil] }).
  #   [1] Array of destroyed associated record field names (e.g., ["association._destroyed"]).
  def collect_destroyed_association_changes
    destroyed_assoc_changes = {}
    destroyed_fields = []

    (_destroyed_associations_audit_data || {}).each do |assoc_name, destroyed_records_data|
      destroyed_records_data.each do |record_data|
        key = "#{assoc_name}.#{record_data[:id]}._destroyed"
        destroyed_assoc_changes[key] = [ record_data[:audit_name], nil ]
        destroyed_fields << "#{assoc_name}._destroyed"
      end
    end

    [ destroyed_assoc_changes, destroyed_fields ]
  end

  # Creates an AuditLog record with the provided information.
  # Ensures a transaction_id is present and prevents duplicate logs within the same transaction.
  # Only creates a log if there are actual audited changes.
  #
  # @param action [String] The action performed ('create', 'update', 'destroy').
  # @param audited_changes [Hash] A hash containing the changes to be logged.
  # @param audited_fields [Array<String>] An array of the names of the fields that changed.
  # @raise [RuntimeError] If a duplicate audit log is found for the same auditable record and transaction ID.
  def log_audit!(action:, audited_changes:, audited_fields: [])
    return if ActiveSupport::IsolatedExecutionState[:auditing_suppressed]

    transaction_id = Current.request_id || SecureRandom.uuid

    if AuditLog.exists?(auditable: self, transaction_id: transaction_id)
      raise "Duplicate audit log for #{self.class.name}##{id} in transaction #{transaction_id}"
    end

    if audited_changes.present?
      AuditLog.create!(
        auditable: self,
        user: Current.user,
        action: action,
        transaction_id: transaction_id,
        created_at: Time.current,
        audited_changes: audited_changes,
        audited_fields: audited_fields.uniq
      )
    end
  end
end
