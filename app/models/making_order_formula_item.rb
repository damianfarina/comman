class MakingOrderFormulaItem < ApplicationRecord
  belongs_to :formula_item
  belongs_to :formula_element
  belongs_to :making_order_formula
end

# == Schema Information
#
# Table name: making_order_formula_items
#
#  id                      :bigint           not null, primary key
#  consumed_stock          :decimal(, )
#  formula_element_name    :string
#  proportion              :decimal(, )
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  formula_element_id      :integer
#  formula_item_id         :integer
#  making_order_formula_id :integer
#
