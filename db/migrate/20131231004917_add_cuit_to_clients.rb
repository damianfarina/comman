class AddCuitToClients < ActiveRecord::Migration
  def change
    add_column :clients, :cuit, :string
  end
end
