class Formula < ActiveRecord::Base
  has_many :products, :dependent => :destroy
  has_many :formula_items, :order => "id", :dependent => :destroy
  has_many :formula_elements, :through => :formula_items

  accepts_nested_attributes_for :formula_items,
    :allow_destroy => true,
    :reject_if => proc { |attrs| attrs.all? { |k, v| v.blank? } }

  validates :abrasive, :grain, :hardness, :porosity, :alloy, :formula_items, :name, :presence => true
  validates :name, :uniqueness => true
  validate :items_proportion_is_one_hundred, :if => 'self.formula_items.any?'

  before_validation :set_name

  private

  def items_proportion_is_one_hundred
    difference = 100.0
    difference = self.formula_items.inject(difference) { |result, item| result -= (item.proportion || 0)  }
    errors[:base] << I18n.t(:items_proportion_should_be_100, :scope => [:activerecord, :errors, :models, :formula], :difference => difference.round(3)) unless (difference.abs < 0.01)
  end

  def set_name
    self.name = (abrasive + grain + hardness + porosity + alloy).gsub(' ', '')
  end
end
