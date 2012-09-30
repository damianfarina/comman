class MakingOrderFormulaItem < ActiveRecord::Base

  belongs_to :formula_item
  belongs_to :formula_element
  belongs_to :making_order_formula

  validates :formula_item_id,
    :formula_element_id,
    :formula_element_name,
    :proportion,
    :presence => true

  after_create :take_formula_element_stock
  # after_update :update_formula_element_stock
  after_destroy :give_back_formula_element_stock

  attr_accessible :formula_item_id, :formula_element_id, :formula_element_name, :proportion

  def making_order
  	self.making_order_formula.making_order
  end

  def formula
  	self.making_order_formula.formula
  end

  private
  
  def give_back_formula_element_stock
    used_stock = self.making_order.total_weight * self.proportion / 100.0
    current_stock = self.formula_item.formula_element.current_stock + used_stock
    self.formula_item.formula_element.update_attributes :current_stock => current_stock
  end

  def take_formula_element_stock
  	used_stock = self.making_order.total_weight * self.proportion / 100.0
  	current_stock = self.formula_item.formula_element.current_stock - used_stock
  	self.formula_item.formula_element.update_attributes :current_stock => current_stock
  end

  def update_formula_element_stock
    return false
  end

end
