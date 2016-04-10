class AddMissingFieldsToMakingOrderFormulas < ActiveRecord::Migration[5.0]
  def change
    add_column :making_order_formulas, :formula_abrasive, :string

    add_column :making_order_formulas, :formula_grain, :string

    add_column :making_order_formulas, :formula_hardness, :string

    add_column :making_order_formulas, :formula_porosity, :string

    add_column :making_order_formulas, :formula_alloy, :string

  end
end
