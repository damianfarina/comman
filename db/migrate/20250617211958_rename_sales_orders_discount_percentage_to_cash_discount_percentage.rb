class RenameSalesOrdersDiscountPercentageToCashDiscountPercentage < ActiveRecord::Migration[8.0]
  def change
    rename_column :sales_orders, :discount_percentage, :cash_discount_percentage
  end
end
