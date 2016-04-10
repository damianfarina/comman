class AddResponsibleRegisteredToClients < ActiveRecord::Migration[5.0]
  def change
    add_column :clients, :responsible_registered, :boolean, :default => false
  end
end
