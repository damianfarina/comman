class FormulaItem < ActiveRecord::Base
  belongs_to :formula
  belongs_to :formula_element
  has_many :making_order_formula_items

  validates :proportion, :presence => true
  validates :formula_element_id, :presence => true

  def formula_element_name
    self.formula_element.try(:name)
  end
end
