class MakingOrderFormula < ActiveRecord::Base
  belongs_to :making_order
  belongs_to :formula
  has_many :making_order_formula_items, :dependent => :destroy

  validates :formula_id,
    :making_order_formula_items,
    :presence => true

  before_validation :build_making_order_formula_items_if_needed
  before_save :fill_formula_fields

  def formula_items
    formula.try(:formula_items) || []
  end

  def to_s
    formula_name
  end

private

  def fill_formula_fields
    self.formula_name = formula.name
    self.formula_abrasive = formula.abrasive
    self.formula_grain = formula.grain
    self.formula_hardness = formula.hardness
    self.formula_porosity = formula.porosity
    self.formula_alloy = formula.alloy
  end

  def build_making_order_formula_items_if_needed
    formula_items.each do |item|
      making_order_formula_items.build :formula_item_id => item.id,
        :formula_element_id => item.formula_element_id,
        :formula_element_name => item.formula_element_name,
        :proportion => item.proportion
    end unless making_order_formula_items.any? or formula_id.nil?
  end

end
