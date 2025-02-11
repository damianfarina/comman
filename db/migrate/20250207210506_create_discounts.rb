class CreateDiscounts < ActiveRecord::Migration[8.0]
  def change
    create_table :discounts do |t|
      t.integer :discount_type, null: false
      t.integer :client_type
      t.decimal :percentage, precision: 5, scale: 2, null: false, default: 0.0

      t.timestamps
    end

    add_index :discounts, :discount_type
    add_index :discounts, :client_type
  end
end
