module Auditable
  extend ActiveSupport::Concern

  included do
    class_attribute :_auditable_config, instance_accessor: false, default: {}
    attr_accessor :_destroyed_associations_audit_data
  end

  class_methods do
    def auditable(only: nil, except: nil)
      raise ArgumentError, "auditable or auditable_attributes already set" if _auditable_config[:attributes]
      self._auditable_config = resolve_auditable_config(only: only, except: except)

      has_many :audit_logs, as: :auditable

      before_update :capture_destroyed_associations_for_auditing
      after_commit :write_audit_log_on_create, on: :create
      after_commit :write_audit_log_on_update, on: :update
      after_commit :write_audit_log_on_destroy, on: :destroy
    end

    def auditable_attributes(only: nil, except: nil)
      raise ArgumentError, "auditable or auditable_attributes already set" if _auditable_config[:attributes]
      self._auditable_config = resolve_auditable_config(only: only, except: except)
    end

    def _auditable_belongs_to_foreign_keys_map
      @_auditable_belongs_to_foreign_keys_map ||= begin
        keys = {}
        (_auditable_config[:associations] || []).each do |assoc_name|
          assoc = reflect_on_association(assoc_name)
          if assoc && assoc.macro == :belongs_to
            keys[assoc.foreign_key.to_s] = assoc_name.to_s
          end
        end
        keys
      end
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
          attrs - [ :created_at, :updated_at, :id ]
        end

      associations = reflect_on_all_associations.map(&:name)
      {
        attributes: tracked - associations,
        associations: tracked & associations,
      }
    end
  end

  def audit_changes_raw
    if destroyed?
      collect_self_destruction_changes
    elsif previously_new_record?
      collect_self_creation_changes
    else
      collect_update_changes
    end
  end

  # Override in your model if name is not meaningful
  def audit_name
    respond_to?(:name) ? name.to_s : "#{self.class.name}##{id}"
  end

  private

  def collect_self_destruction_changes
    {
      "audited_changes" => { "_destroyed" => [ audit_name, nil ] },
      "audited_fields" => [ "_destroyed" ],
    }
  end

  def collect_self_creation_changes
    {
      "audited_changes" => { "_created" => [ nil, audit_name ] },
      "audited_fields" => [ "_created" ],
    }
  end

  def collect_update_changes
    audited_changes = {}
    audited_fields = []

    # Collect changes from the record's own attributes (including belongs_to)
    attribute_changes, attribute_fields = collect_attribute_and_belongs_to_changes
    audited_changes.merge!(attribute_changes)
    audited_fields.concat(attribute_fields)

    # Collect changes from has_many/has_one associations (creations/updates)
    assoc_changes, changed_fields = collect_association_changes
    audited_changes.merge!(assoc_changes)
    audited_fields.concat(changed_fields)

    # Collect changes from destroyed has_many/has_one associations
    destroyed_assoc_changes, destroyed_fields = collect_destroyed_association_changes
    audited_changes.merge!(destroyed_assoc_changes)
    audited_fields.concat(destroyed_fields)

    {
      "audited_changes" => audited_changes,
      "audited_fields" => audited_fields.uniq,
    }
  end

  def collect_attribute_and_belongs_to_changes
    audited_changes = {}
    audited_fields = []
    tracked_attrs_strings = self.class._auditable_config[:attributes].map(&:to_s)

    previous_changes.each do |attribute, change|
      belongs_to_assoc = belongs_to_association_for_foreign_key(attribute)

      if belongs_to_assoc
        belongs_to_changes = process_belongs_to_change(belongs_to_assoc, change)

        audited_changes.merge!(belongs_to_changes[:changes])
        audited_fields.concat(belongs_to_changes[:fields])
      elsif tracked_attrs_strings.include?(attribute)
         audited_changes[attribute] = change
         audited_fields << attribute
      end
    end

    [ audited_changes, audited_fields ]
  end

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

  def find_associated_record_name_by_id(belongs_to_assoc, id)
    return nil unless id.present?

    record = belongs_to_assoc.klass.find_by(belongs_to_assoc.active_record_primary_key => id)
    record.try(:audit_name)
  end

  def belongs_to_association_for_foreign_key(attribute)
    assoc_name = self.class._auditable_belongs_to_foreign_keys_map[attribute]
    assoc_name ? self.class.reflect_on_association(assoc_name.to_sym) : nil
  end

  def capture_destroyed_associations_for_auditing
    self._destroyed_associations_audit_data = {}
    (self.class._auditable_config[:associations] || []).each do |assoc_name|
      assoc = self.class.reflect_on_association(assoc_name.to_sym)

      if assoc && (assoc.macro == :has_many || assoc.macro == :has_one) && self.respond_to?("#{assoc_name}_attributes=")
        Array(send(assoc_name).target).each do |record|
          if record.persisted? && record.marked_for_destruction? && record.respond_to?(:audit_name)
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

    log_audit!(action: "update", audited_changes: all_changes, audited_fields: raw_changes["audited_fields"])
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
