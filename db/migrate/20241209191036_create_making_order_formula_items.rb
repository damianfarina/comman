class CreateMakingOrderFormulaItems < ActiveRecord::Migration[8.0]
  def change
    create_table :making_order_formula_items do |t|
      t.integer :making_order_formula_id
      t.integer :formula_item_id
      t.integer :formula_element_id
      t.string :formula_element_name
      t.decimal :proportion
      t.decimal :consumed_stock

      t.timestamps
    end
  end
end
