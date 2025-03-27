class AddTaxIdentificationUniqueIndexToClients < ActiveRecord::Migration[8.0]
  def change
    add_index :clients, :tax_identification, unique: true
  end
end
