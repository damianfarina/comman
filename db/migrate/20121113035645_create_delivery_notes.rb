class CreateDeliveryNotes < ActiveRecord::Migration
  def change
    create_table :delivery_notes do |t|
      t.integer :client_id
      t.text :comments
      t.integer :state, :default => 0

      t.timestamps
    end
  end
end
