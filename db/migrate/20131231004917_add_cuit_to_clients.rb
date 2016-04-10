class AddCuitToClients < ActiveRecord::Migration[5.0]
  def change
    add_column :clients, :cuit, :string
  end
end
