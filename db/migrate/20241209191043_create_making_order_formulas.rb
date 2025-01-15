class CreateMakingOrderFormulas < ActiveRecord::Migration[8.0]
  def change
    create_table :making_order_formulas do |t|
      t.integer :formula_id
      t.integer :making_order_id
      t.string :formula_name
      t.string :formula_abrasive
      t.string :formula_grain
      t.string :formula_hardness
      t.string :formula_porosity
      t.string :formula_alloy

      t.timestamps
    end
  end
end
