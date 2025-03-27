class MakingOrder < ApplicationRecord
  include HasRichComments

  has_one :making_order_formula, dependent: :destroy
  delegate :formula, :formula_id, :formula_name, to: :making_order_formula, allow_nil: true
  has_many :making_order_items, dependent: :destroy
  has_many :making_order_formula_items, through: :making_order_formula, autosave: true

  accepts_nested_attributes_for :making_order_items, allow_destroy: true, reject_if: :all_blank

  enum :state, in_progress: 0, completed: 1, canceled: 2

  validates :making_order_formula, :making_order_items, :mixer_capacity, presence: true
  validates :mixer_capacity, numericality: { greater_than: 1 }, if: -> { self.mixer_capacity.present? }
  validate :products_belongs_to_the_same_formula, if: :are_there_valid_products?

  before_validation :set_making_order_formula, if: -> { need_formula_and_is_available? }
  before_validation :set_total_weight
  before_validation :set_rounds_count
  before_validation :set_weight_per_round
  before_update :set_formula_dirty, if: -> { self.total_weight_changed? }

  def self.ransackable_attributes(auth_object = nil)
    %w[id comments_plain_text mixer_capacity rounds_count state making_order_formula_name total_weight created_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[making_order_formula]
  end

  ransacker :making_order_formula_name do |parent|
    Arel.sql("making_order_formulas.formula_name")
  end

  private

    def set_rounds_count
      self.rounds_count = (total_weight / mixer_capacity).ceil
    end

    def set_weight_per_round
      self.weight_per_round = total_weight / rounds_count
    end

    def set_total_weight
      self.total_weight = self.making_order_items.reject(&:marked_for_destruction?).sum { |item| item.product.productable.weight * (item.quantity || 0) }
    end

    def set_making_order_formula
      productable = making_order_items.first.product.productable
      self.build_making_order_formula(formula_id: productable.formula_id)
    end

    def set_formula_dirty
      self.making_order_formula_items.each { |item| item.consumed_stock_will_change! }
    end

    def products_belongs_to_the_same_formula
      self.making_order_items.each do |item|
        next unless item.changed?

        unless item.product.productable.formula_id == self.making_order_formula.formula_id
          errors.add(
            :base,
            I18n.t(:products_formula_is_different, scope: [ :activerecord, :errors, :models, :making_order ])
          )
        end
      end
    end

    def need_formula_and_is_available?
      making_order_formula.nil? && are_there_valid_products?
    end

    def are_there_valid_products?
      items = making_order_items.reject(&:marked_for_destruction?)
      items.any? && items.first.product_id.present?
    end
end

# == Schema Information
#
# Table name: making_orders
#
#  id                  :bigint           not null, primary key
#  comments_plain_text :text
#  mixer_capacity      :float            default(60.0)
#  rounds_count        :integer
#  state               :integer          default("in_progress")
#  total_weight        :decimal(, )
#  weight_per_round    :decimal(, )
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
