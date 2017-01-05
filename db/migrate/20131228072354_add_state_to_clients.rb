class AddStateToClients < ActiveRecord::Migration[5.0]
  def change
    add_column :clients, :state, :string, :default => 'Mendoza'
  end
end
