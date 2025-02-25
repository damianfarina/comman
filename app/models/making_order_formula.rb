class MakingOrderFormula < ApplicationRecord
  belongs_to :making_order
  belongs_to :formula
  has_many :making_order_formula_items, -> { order(id: :asc) }, dependent: :destroy

  validates :making_order_formula_items, presence: true

  before_validation :prepare_making_order_formula_items, unless: -> { making_order_formula_items.any? || formula_id.nil? }
  before_validation :prepare_formula_fields, if: -> { formula_id.present? }

  private

    def prepare_making_order_formula_items
      formula.formula_items.each do |formula_item|
        making_order_formula_items.build(
          formula_item_id: formula_item.id,
          formula_element_id: formula_item.formula_element_id,
          formula_element_name: formula_item.formula_element_name,
          proportion: formula_item.proportion,
        )
      end
    end

    def prepare_formula_fields
      self.formula_name = formula.name
      self.formula_abrasive = formula.abrasive
      self.formula_grain = formula.grain
      self.formula_hardness = formula.hardness
      self.formula_porosity = formula.porosity
      self.formula_alloy = formula.alloy
    end
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
