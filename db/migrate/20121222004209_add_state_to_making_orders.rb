class AddStateToMakingOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :making_orders, :state, :integer, :default => 0
    MakingOrder.reset_column_information
    MakingOrder.update_all(:state => 1)
  end
end
