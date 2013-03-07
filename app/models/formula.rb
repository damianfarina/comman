class Formula < ActiveRecord::Base
  has_many :products, :dependent => :destroy
  has_many :formula_items, :order => "id", :dependent => :destroy
  has_many :formula_elements, :through => :formula_items
  has_many :making_order_formulas, :dependent => :nullify

  accepts_nested_attributes_for :formula_items,
    :allow_destroy => true,
    :reject_if => proc { |attrs| attrs.all? { |k, v| v.blank? } }

  validates :abrasive, :grain, :hardness, :porosity, :alloy, :formula_items, :name, :presence => true
  validate :name_is_unique, :unless => 'self.name.nil?'
  validate :items_proportion_is_one_hundred, :if => 'self.formula_items.any?'

  before_validation :set_name

  attr_accessible :abrasive, :grain, :hardness, :porosity, :alloy, :formula_items_attributes

  self.per_page = 25

private

  def items_proportion_is_one_hundred
    difference = 100.0
    difference = self.formula_items.inject(difference) do |result, item|
      unless item.marked_for_destruction?
        result -= (item.proportion || 0)
      end
      result
    end
    errors[:base] << I18n.t(:items_proportion_should_be_100, :scope => [:activerecord, :errors, :models, :formula],
      :difference => difference.round(3)) unless (difference.abs < 0.01)
  end

  def set_name
    self.name = (abrasive + grain + hardness + porosity + alloy).gsub(' ', '')
  end

  def name_is_unique
    other_formula = Formula.find_by_name(self.name)
    errors[:base] << I18n.t(:name_must_be_unique, :scope => [:activerecord, :errors, :models, :formula],
      :other_formula_id => other_formula.id,
      :other_formula_name => other_formula.name) if other_formula and other_formula.id != self.id
  end
end
