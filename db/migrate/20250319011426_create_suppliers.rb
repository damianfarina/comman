class CreateSuppliers < ActiveRecord::Migration[8.0]
  def change
    create_table :suppliers do |t|
      t.string :name, null: false
      t.string :tax_identification, null: false
      t.string :address
      t.string :country
      t.string :province
      t.string :zipcode
      t.string :maps_url
      t.string :phone
      t.string :email
      t.string :bank_name
      t.string :bank_account_number
      t.string :routing_number
      t.integer :tax_type, default: 0
      t.text :comments_plain_text
      t.boolean :in_house, default: false

      t.timestamps
    end
    add_index :suppliers, :tax_identification, unique: true
  end
end
