class CreateSalesOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :sales_orders do |t|
      t.references :client, null: false, foreign_key: true
      t.string :status, null: false, default: "quote"
      t.datetime :confirmed_at
      t.datetime :fulfilled_at
      t.datetime :canceled_at
      t.decimal :total_price, precision: 12, scale: 2, null: true
      t.text :comments_plain_text
      t.decimal :discount_percentage, precision: 5, scale: 2, null: false

      t.timestamps
    end

    add_index :sales_orders, :status
  end
end
