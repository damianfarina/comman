class CreateDeliveryNoteItems < ActiveRecord::Migration
  def change
    create_table :delivery_note_items do |t|
      t.integer :delivery_note_id
      t.integer :product_id
      t.integer :quantity

      t.timestamps
    end
  end
end
