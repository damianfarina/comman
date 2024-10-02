class CreateFormulaElements < ActiveRecord::Migration[7.2]
  def change
    create_table :formula_elements do |t|
      t.string :name
      t.float :min_stock, default: 1.0
      t.float :current_stock, default: 0.0
      t.boolean :infinite

      t.timestamps
    end
  end
end
