class AddResponsibleRegisteredToClients < ActiveRecord::Migration
  def change
    add_column :clients, :responsible_registered, :boolean, :default => false
  end
end
