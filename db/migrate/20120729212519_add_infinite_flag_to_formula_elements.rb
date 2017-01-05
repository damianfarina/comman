class AddInfiniteFlagToFormulaElements < ActiveRecord::Migration[5.0]
  def change
    add_column :formula_elements, :infinite, :boolean

  end
end
