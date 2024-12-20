class ChangeDefaultMixerCapacityInMakingOrders < ActiveRecord::Migration[8.0]
  def change
    change_column_default :making_orders, :mixer_capacity, 60.0
  end
end
