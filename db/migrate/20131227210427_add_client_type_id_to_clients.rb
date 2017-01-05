class AddClientTypeIdToClients < ActiveRecord::Migration[5.0]
  def change
    add_column :clients, :client_type_id, :integer
  end
end
