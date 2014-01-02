class AddDiscountToClients < ActiveRecord::Migration
  def change
    add_column :clients, :discount, :float, :default => 0.0
  end
end
