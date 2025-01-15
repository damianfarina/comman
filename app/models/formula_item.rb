class FormulaItem < ApplicationRecord
  belongs_to :formula
  belongs_to :formula_element
  has_many :making_order_formula_items, dependent: :nullify

  delegate :name, to: :formula_element, allow_nil: true, prefix: true

  validates :proportion, presence: true
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
