class AddExtraFieldsToProducts < ActiveRecord::Migration[5.0]
  def change
    add_column :products, :shape, :string
    add_column :products, :size, :string
    add_column :products, :weight, :decimal
    add_column :products, :pressure, :string
  end
end
