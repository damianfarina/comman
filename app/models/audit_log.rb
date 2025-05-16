class AuditLog < ApplicationRecord
  belongs_to :auditable, polymorphic: true, autosave: false
  belongs_to :user, optional: true

  validates :action, presence: true, inclusion: { in: %w[create update destroy] }
  validates :audited_changes, presence: true
  validates :audited_fields, presence: true

  scope :recent, -> { order(created_at: :desc) }
  scope :for_model, ->(model_class) { where(auditable_type: model_class.name) }
  scope :for_instance, ->(record) { where(auditable_type: record.class.name, auditable_id: record.id) }

  def changed?(attribute)
    audited_fields.include?(attribute.to_s)
  end
end

# == Schema Information
#
# Table name: audit_logs
#
#  id              :bigint           not null, primary key
#  action          :string           not null
#  auditable_type  :string           not null
#  audited_changes :jsonb            not null
#  audited_fields  :string           default([]), not null, is an Array
#  created_at      :datetime         not null
#  auditable_id    :bigint           not null
#  transaction_id  :string
#  user_id         :bigint
#
# Indexes
#
#  index_audit_logs_on_auditable_type_and_auditable_id  (auditable_type,auditable_id)
#  index_audit_logs_on_audited_fields                   (audited_fields) USING gin
#  index_audit_logs_on_user_id                          (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
