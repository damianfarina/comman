class FormulaItem < ActiveRecord::Base
  belongs_to :formula
  belongs_to :formula_element
  delegate :name, :to => :formula_element, :allow_nil => true, :prefix => true
  has_many :making_order_formula_items

  validates :proportion, :presence => true
  validates :formula_element_id, :presence => true

  attr_accessible :autocomplete_formula_element_name, :formula_element_id, :proportion
end
