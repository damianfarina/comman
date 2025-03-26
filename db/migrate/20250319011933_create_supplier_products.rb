class CreateSupplierProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :supplier_products do |t|
      t.references :supplier, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.decimal :price, null: false, precision: 10, scale: 2
      t.string :code

      t.timestamps
    end
  end
end
