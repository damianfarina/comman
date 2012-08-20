class AddInfiniteFlagToFormulaElements < ActiveRecord::Migration
  def change
    add_column :formula_elements, :infinite, :boolean

  end
end
