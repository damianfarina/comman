class AddMixerCapacityToMakingOrders < ActiveRecord::Migration
  def change
    add_column :making_orders, :mixer_capacity, :float, :default => 60.0

  end
end
