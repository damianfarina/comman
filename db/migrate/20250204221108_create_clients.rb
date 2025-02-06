class CreateClients < ActiveRecord::Migration[8.0]
  def change
    create_table :clients do |t|
      t.string :name, null: false
      t.string :tax_identification, null: false
      t.string :address
      t.string :zipcode
      t.string :country
      t.string :province
      t.string :maps_url
      t.string :phone
      t.string :email
      t.integer :client_type, default: 0

      t.timestamps
    end
  end
end
