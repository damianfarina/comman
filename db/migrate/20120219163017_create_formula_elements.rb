class CreateFormulaElements < ActiveRecord::Migration[5.0]
  def change
    create_table :formula_elements do |t|
      t.string :name

      t.timestamps
    end
  end
end
