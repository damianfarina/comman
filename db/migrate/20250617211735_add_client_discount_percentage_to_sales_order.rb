class AddClientDiscountPercentageToSalesOrder < ActiveRecord::Migration[8.0]
  def change
    add_column :sales_orders, :client_discount_percentage, :decimal, precision: 5, scale: 2, default: 0.0, null: false
  end
end
