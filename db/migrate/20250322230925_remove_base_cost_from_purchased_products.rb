class RemoveBaseCostFromPurchasedProducts < ActiveRecord::Migration[8.0]
  def change
    remove_column :purchased_products, :base_cost, :decimal
  end
end
