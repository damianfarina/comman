class ChangeProportionTypeToDecimal < ActiveRecord::Migration[5.0]
  def up
    change_column :making_order_formula_items, :proportion, :decimal
  end

  def down
    change_column :making_order_formula_items, :proportion, :integer
  end
end
