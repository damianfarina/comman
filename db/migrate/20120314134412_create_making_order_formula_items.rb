class CreateMakingOrderFormulaItems < ActiveRecord::Migration
  def change
    create_table :making_order_formula_items do |t|
      t.integer :making_order_formula_id
      t.integer :formula_item_id
      t.integer :formula_element_id
      t.string :formula_element_name
      t.integer :proportion
      t.timestamps
    end
  end
end
