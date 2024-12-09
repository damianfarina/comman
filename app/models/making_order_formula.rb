class MakingOrderFormula < ApplicationRecord
  belongs_to :making_order
  belongs_to :formula
  has_many :making_order_formula_items, dependent: :destroy
end

# == Schema Information
#
# Table name: making_order_formulas
#
#  id               :bigint           not null, primary key
#  formula_abrasive :string
#  formula_alloy    :string
#  formula_grain    :string
#  formula_hardness :string
#  formula_name     :string
#  formula_porosity :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  formula_id       :integer
#  making_order_id  :integer
#
