class AddBalanceToClient < ActiveRecord::Migration
  def change
    add_column :clients, :balance, :float, :default => 0.0
  end
end
