class CreateMakingOrderItems < ActiveRecord::Migration
  def change
    create_table :making_order_items do |t|
      t.integer :making_order_id
      t.integer :product_id
      t.integer :quantity
      t.string :product_name
      t.string :product_shape
      t.string :product_size
      t.decimal :product_weight
      t.decimal :product_pressure
      t.timestamps
    end
  end
end
