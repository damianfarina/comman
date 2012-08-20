class CreateFormulaElements < ActiveRecord::Migration
  def change
    create_table :formula_elements do |t|
      t.string :name

      t.timestamps
    end
  end
end
