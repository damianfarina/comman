class AddConsumedStockToMakingOrderFormulaItems < ActiveRecord::Migration[5.0]
  def up
    add_column :making_order_formula_items, :consumed_stock, :decimal
    MakingOrderFormulaItem.find_each(:batch_size => 10) do |m|
      m.update_attributes :consumed_stock => m.making_order_formula.making_order.total_weight * m.proportion / 100.0
    end
  end

  def down
    remove_column :making_order_formula_items, :consumed_stock
  end
end
