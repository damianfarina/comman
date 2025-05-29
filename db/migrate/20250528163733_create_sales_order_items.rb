class CreateSalesOrderItems < ActiveRecord::Migration[8.0]
  def change
    create_table :sales_order_items do |t|
      t.references :sales_order, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.integer :quantity
      t.decimal :unit_price, precision: 10, scale: 2, null: false
      t.string :status, null: false, default: "quote"

      t.timestamps
    end

    add_index :sales_order_items, :status
  end
end
