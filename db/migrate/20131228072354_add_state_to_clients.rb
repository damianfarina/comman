class AddStateToClients < ActiveRecord::Migration
  def change
    add_column :clients, :state, :string, :default => 'Mendoza'
  end
end
