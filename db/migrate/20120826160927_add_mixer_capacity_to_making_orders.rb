class AddMixerCapacityToMakingOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :making_orders, :mixer_capacity, :float, :default => 60.0

  end
end
