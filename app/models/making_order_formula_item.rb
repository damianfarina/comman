class MakingOrderFormulaItem < ActiveRecord::Base

  belongs_to :formula_item
  belongs_to :formula_element
  belongs_to :making_order_formula

  validates :formula_item_id,
    :formula_element_id,
    :formula_element_name,
    :proportion,
    :presence => true

  before_save :calculate_consumed_stock
  after_create :take_formula_element_stock
  after_update :update_formula_element_stock
  after_destroy :give_back_formula_element_stock

  attr_accessible :formula_item_id, :formula_element_id, :formula_element_name, :proportion, :consumed_stock

  def making_order
  	self.making_order_formula.making_order
  end

  def formula
  	self.making_order_formula.formula
  end

  def cancel!
    give_back_formula_element_stock
    self.update_column :consumed_stock, 0.0
  end

private

  def calculate_consumed_stock
    self.consumed_stock = self.making_order.total_weight * self.proportion / 100.0
  end

  def give_back_formula_element_stock
    return if self.formula_item.nil?
    return if self.formula_item.formula_element.nil?

    current_stock = self.formula_item.formula_element.current_stock + self.consumed_stock
    self.formula_item.formula_element.update_attributes :current_stock => current_stock
  end

  def take_formula_element_stock
  	current_stock = self.formula_item.formula_element.current_stock - self.consumed_stock
  	self.formula_item.formula_element.update_attributes :current_stock => current_stock
  end

  def update_formula_element_stock
    return unless self.consumed_stock_changed?
    return if self.formula_item.nil?
    return if self.formula_item.formula_element.nil?

    diff = self.consumed_stock_was - self.consumed_stock
    current = self.formula_item.formula_element.current_stock + diff
    self.formula_item.formula_element.update_attributes :current_stock => current
  end

end
