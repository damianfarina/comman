class AddDiscountToClients < ActiveRecord::Migration[5.0]
  def change
    add_column :clients, :discount, :float, :default => 0.0
  end
end
