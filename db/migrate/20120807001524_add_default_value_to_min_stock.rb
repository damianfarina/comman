class AddDefaultValueToMinStock < ActiveRecord::Migration
  def change
  	change_column :formula_elements, :min_stock, :float, :default => 1.0
  end
end
