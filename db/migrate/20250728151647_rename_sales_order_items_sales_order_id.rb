class RenameSalesOrderItemsSalesOrderId < ActiveRecord::Migration[8.0]
  def change
    rename_column :sales_order_items, :sales_order_id, :order_id
  end
end
