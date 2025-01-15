class AddDefaultToStateInMakingOrders < ActiveRecord::Migration[8.0]
  def change
    change_column_default :making_orders, :state, from: nil, to: 0
  end
end
