class ChangeMakingOrderItemPressure < ActiveRecord::Migration[5.0]
  def up
    change_column :making_order_items, :product_pressure, :string
  end

  def down
    change_column :making_order_items, :product_pressure, :decimal
  end
end
