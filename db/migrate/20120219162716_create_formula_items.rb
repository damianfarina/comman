class CreateFormulaItems < ActiveRecord::Migration
  def change
    create_table :formula_items do |t|
      t.integer :formula_id
      t.integer :formula_element_id
      t.decimal :proportion

      t.timestamps
    end
  end
end
