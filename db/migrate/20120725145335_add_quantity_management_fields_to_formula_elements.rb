class AddQuantityManagementFieldsToFormulaElements < ActiveRecord::Migration
  def change
    add_column :formula_elements, :min_stock, :float, :default => 0
    add_column :formula_elements, :current_stock, :float, :default => 0
  end
end
