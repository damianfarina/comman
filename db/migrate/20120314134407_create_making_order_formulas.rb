class CreateMakingOrderFormulas < ActiveRecord::Migration[5.0]
  def change
    create_table :making_order_formulas do |t|
      t.integer :formula_id
      t.integer :making_order_id
      t.string :formula_name
      t.timestamps
    end
  end
end
