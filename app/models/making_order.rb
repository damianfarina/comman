class MakingOrder < ActiveRecord::Base
  has_one :making_order_formula, :dependent => :destroy
  has_many :making_order_items, :dependent => :destroy

  accepts_nested_attributes_for :making_order_items,
    :reject_if => proc { |attrs| attrs.all? { |k, v| v.blank? } }

  attr_accessor :mixer_capacity

  validates :making_order_formula,
    :making_order_items,
    :mixer_capacity,
    :presence => true

  validate :products_belongs_to_the_same_formula, :if => :are_there_valid_products?

  before_validation :build_making_order_formula_if_needed
  before_save :calculate_total_weight
  before_save :calculate_rounds_count
  before_save :calculate_weight_per_round

  def formula_name
    making_order_formula.try :formula_name
  end

  def formula
    making_order_formula.try :formula
  end

private

  def products_belongs_to_the_same_formula
    self.making_order_items.each do |item|
      errors[:base] << I18n.t(:products_formula_is_different, :scope => [:activerecord, :errors, :models, :making_order]) unless item.product.formula_id == self.making_order_formula.formula_id
    end
  end

  def build_making_order_formula_if_needed
    self.build_making_order_formula :formula_id => making_order_items.first.product.formula_id if need_formula_and_is_available?
  end

  def calculate_total_weight
    self.total_weight = making_order_items.inject(0.0) { |r, i| r + (i.product.weight * i.quantity)  }
  end

  def calculate_rounds_count
    self.rounds_count = (total_weight / mixer_capacity.to_f).ceil
  end

  def calculate_weight_per_round
    self.weight_per_round = total_weight / rounds_count
  end

  def need_formula_and_is_available?
    making_order_formula.nil? and are_there_valid_products?
  end

  def are_there_valid_products?
    making_order_items.any? and making_order_items.first.product_id.present?
  end
end
