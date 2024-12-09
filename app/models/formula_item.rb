class FormulaItem < ApplicationRecord
  belongs_to :formula
  belongs_to :formula_element
end

# == Schema Information
#
# Table name: formula_items
#
#  id                 :bigint           not null, primary key
#  proportion         :decimal(, )
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  formula_element_id :integer
#  formula_id         :integer
#
