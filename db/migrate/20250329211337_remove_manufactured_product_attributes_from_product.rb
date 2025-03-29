class RemoveManufacturedProductAttributesFromProduct < ActiveRecord::Migration[8.0]
  def change
    remove_column :products, :formula_id, :integer
    remove_column :products, :weight, :decimal
    remove_column :products, :pressure, :string
    remove_column :products, :size, :string
    remove_column :products, :shape, :string
  end
end
