class CreateAuditLogs < ActiveRecord::Migration[8.0]
  def change
    create_table :audit_logs do |t|
      t.string :auditable_type, null: false
      t.bigint :auditable_id, null: false
      t.string :action, null: false
      t.jsonb :audited_changes, default: {}, null: false
      t.string :audited_fields, array: true, default: [], null: false
      t.references :user, null: true, foreign_key: true
      t.string :transaction_id
      t.datetime :created_at, null: false
    end

    add_index :audit_logs, [ :auditable_type, :auditable_id ]
    add_index :audit_logs, :audited_fields, using: :gin
  end
end
