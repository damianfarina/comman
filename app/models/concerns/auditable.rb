module Auditable
  extend ActiveSupport::Concern

  included do
    class_attribute :_auditable_config, instance_accessor: false, default: {}
    attr_accessor :_destroyed_associations_audit_data
  end

  class_methods do
    # Make sure to call any of these methods in the model class
    # after any other callbacks and association definitions

    def auditable(only: nil, except: nil)
      raise ArgumentError, "auditable or auditable_attributes already set" if _auditable_config[:attributes]
      self._auditable_config = resolve_auditable_config(only: only, except: except)

      before_update :capture_destroyed_associations_for_auditing

      after_commit :write_audit_log_on_create, on: :create
      after_commit :write_audit_log_on_update, on: :update
      after_commit :write_audit_log_on_destroy, on: :destroy

      has_many :audit_logs, as: :auditable
    end

    def auditable_attributes(only: nil, except: nil)
      raise ArgumentError, "auditable or auditable_attributes already set" if _auditable_config[:attributes]
      self._auditable_config = resolve_auditable_config(only: only, except: except)
    end

    private

    def resolve_auditable_config(only:, except:)
      attrs = column_names.map(&:to_sym)
      tracked =
        if only
          only.map(&:to_sym)
        elsif except
          attrs - except.map(&:to_sym)
        else
          attrs - [ :created_at, :updated_at ]
        end

      associations = reflect_on_all_associations.map(&:name)
      {
        attributes: tracked - associations,
        associations: tracked & associations,
      }
    end
  end

  # Override in your model if name is not meaningful
  def audit_name
    respond_to?(:name) ? name.to_s : "#{self.class.name}##{id}"
  end

  # This method reports changes based on the *final* state after commit
  # Called by parent models to extract changes
  def audit_changes_raw
    tracked_attrs = self.class._auditable_config[:attributes] || []

    if destroyed?
      {
        "audited_changes" => { "_destroyed" => [ audit_name, nil ] },
        "audited_fields" => [ "_destroyed" ],
      }
    elsif previously_new_record?
      {
        "audited_changes" => { "_created" => [ nil, audit_name ] },
        "audited_fields" => [ "_created" ],
      }
    else
      changes = previous_changes.slice(*tracked_attrs.map(&:to_s))
      assoc_changes, changed_fields = collect_association_changes

      destroyed_assoc_changes, destroyed_fields = collect_destroyed_association_changes

      {
        "audited_changes" => changes.merge(assoc_changes).merge(destroyed_assoc_changes),
        "audited_fields" => (changes.keys + changed_fields + destroyed_fields).uniq,
      }
    end
  end

  private

  # Callback to capture destroyed associations before they are gone
  def capture_destroyed_associations_for_auditing
    (self.class._auditable_config[:associations] || []).each do |assoc_name|
      Array(send(assoc_name).target).each do |record|
        if record.persisted? && record.marked_for_destruction?
          self._destroyed_associations_audit_data = {}
          self._destroyed_associations_audit_data[assoc_name] ||= []
          self._destroyed_associations_audit_data[assoc_name] << {
            id: record.id,
            audit_name: record.audit_name,
          }
        end
      end
    end
  end

  def write_audit_log_on_create
    return unless self.class._auditable_config

    log_audit!(
      action: "create",
      audited_changes: audit_changes_raw["audited_changes"],
      audited_fields: audit_changes_raw["audited_fields"],
    )
  end

  def write_audit_log_on_update
    return unless self.class._auditable_config

    raw_changes = audit_changes_raw
    all_changes = raw_changes["audited_changes"]

    return if all_changes.empty?

    log_audit!(
      action: "update",
      audited_changes: all_changes,
      audited_fields: raw_changes["audited_fields"],
    )
  end

  def write_audit_log_on_destroy
    return unless self.class._auditable_config

    log_audit!(
      action: "destroy",
      audited_changes: audit_changes_raw["audited_changes"],
      audited_fields: audit_changes_raw["audited_fields"],
    )
  end

  def collect_association_changes
    assoc_changes = {}
    changed_fields = []

    (self.class._auditable_config[:associations] || []).each do |assoc_name|
      records = Array(send(assoc_name))
      records.each do |record|
        # Skip records that are marked for destruction; they are handled by collect_destroyed_association_changes
        next if record.marked_for_destruction?

        raw = record.audit_changes_raw
        # We only care about changes/creations on associated records here
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

  def log_audit!(action:, audited_changes:, audited_fields: [])
    transaction_id = Current.request_id || SecureRandom.uuid

    if AuditLog.exists?(auditable: self, transaction_id: transaction_id)
      raise "Duplicate audit log for #{self.class.name}##{id} in transaction #{transaction_id}"
    end

    # Only create a log if there are actual changes to record
    # This check is mainly for update action, as create/destroy always have changes
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
