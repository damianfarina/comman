class MakingOrder < ApplicationRecord

  STATE_WORKING = 0
  STATE_FINISHED = 1
  STATE_CANCELED = 2

  has_one :making_order_formula, :dependent => :destroy
  delegate :formula, :formula_id, :formula_name, :to => :making_order_formula, :allow_nil => true
  has_many :making_order_items, :dependent => :destroy
  has_many :making_order_formula_items, :through => :making_order_formula, :autosave => true

  accepts_nested_attributes_for :making_order_items, :allow_destroy => true,
    :reject_if => proc { |attrs| attrs.all? { |k, v| v.blank? } }

  validates :making_order_formula,
    :making_order_items,
    :mixer_capacity,
    :presence => true
  validates :mixer_capacity, :numericality => { :greater_than => 1}, :if => 'self.mixer_capacity.present?'
  validate :products_belongs_to_the_same_formula, :if => :are_there_valid_products?

  before_validation :build_making_order_formula_if_needed
  before_save :calculate_total_weight
  before_save :calculate_rounds_count
  before_save :calculate_weight_per_round
  before_update :set_formula_dirty, :if => 'self.total_weight_changed?'

  def cancel!
    self.update_column :state, MakingOrder::STATE_CANCELED
    self.making_order_formula_items.each { |i| i.cancel! }
  end

private

  def set_formula_dirty
    self.making_order_formula_items.each {|i| i.consumed_stock_will_change!}
  end

  def products_belongs_to_the_same_formula
    self.making_order_items.each do |item|
      errors[:base] << I18n.t(:products_formula_is_different, :scope => [:activerecord, :errors, :models, :making_order]) unless item.product.formula_id == self.making_order_formula.formula_id
    end
  end

  def build_making_order_formula_if_needed
    self.build_making_order_formula :formula_id => making_order_items.first.product.formula_id if need_formula_and_is_available?
  end

  def calculate_total_weight
    self.total_weight = making_order_items.reject(&:marked_for_destruction?).inject(0.0) do |r, i|
      r + (i.product.weight * i.quantity)
    end
  end

  def calculate_rounds_count
    self.rounds_count = (self.total_weight / self.mixer_capacity).ceil
  end

  def calculate_weight_per_round
    self.weight_per_round = self.total_weight / self.rounds_count
  end

  def need_formula_and_is_available?
    making_order_formula.nil? and are_there_valid_products?
  end

  def are_there_valid_products?
    items = making_order_items.reject(&:marked_for_destruction?)
    items.any? and items.first.product_id.present?
  end
end
