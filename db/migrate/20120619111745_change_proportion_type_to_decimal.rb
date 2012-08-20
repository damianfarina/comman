class ChangeProportionTypeToDecimal < ActiveRecord::Migration
  def up
    change_column :making_order_formula_items, :proportion, :decimal
  end

  def down
    change_column :making_order_formula_items, :proportion, :integer
  end
end
