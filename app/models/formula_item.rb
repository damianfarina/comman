class FormulaItem < ApplicationRecord
  belongs_to :formula
  belongs_to :formula_element
end

# == Schema Information
#
# Table name: formula_items
#
#  id                 :integer          not null, primary key
#  formula_id         :integer
#  formula_element_id :integer
#  proportion         :decimal(, )
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
