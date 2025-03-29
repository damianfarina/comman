class AddIndexToProductsOnProductable < ActiveRecord::Migration[8.0]
  def change
    add_index :products, [ :productable_type, :productable_id ]
  end
end
