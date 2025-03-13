class UpdateProducts < ActiveRecord::Migration[8.0]
  def change
    add_column :products, :productable_type, :string
    add_column :products, :productable_id, :integer
    add_column :products, :current_stock, :integer, default: 0, null: false
    add_column :products, :min_stock, :integer, default: 0, null: false
    add_column :products, :max_stock, :integer, default: 0, null: false
    add_column :products, :description, :text
  end
end
