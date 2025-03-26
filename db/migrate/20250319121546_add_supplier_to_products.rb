class AddSupplierToProducts < ActiveRecord::Migration[8.0]
  def change
    add_reference :products, :supplier, foreign_key: { to_table: :suppliers }, null: true
  end
end
