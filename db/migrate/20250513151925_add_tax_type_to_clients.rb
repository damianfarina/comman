class AddTaxTypeToClients < ActiveRecord::Migration[8.0]
  def change
    add_column :clients, :tax_type, :integer
  end
end
