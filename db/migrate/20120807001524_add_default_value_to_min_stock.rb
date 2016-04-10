class AddDefaultValueToMinStock < ActiveRecord::Migration[5.0]
  def change
  	change_column :formula_elements, :min_stock, :float, :default => 1.0
  end
end
