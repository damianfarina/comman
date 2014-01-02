class AddCountryToClients < ActiveRecord::Migration
  def change
    add_column :clients, :country, :string, :default => 'Argentina'
  end
end
