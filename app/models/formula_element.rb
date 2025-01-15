class FormulaElement < ApplicationRecord
  has_many :formula_items
  has_many :formulas, -> { distinct }, through: :formula_items
  has_many :products, -> { distinct }, through: :formulas

  validates :name, presence: true, uniqueness: true
  validates :min_stock, :current_stock, presence: true, unless: :infinite?
  validates :min_stock, numericality: { greater_than_or_equal_to: 0 }, if: -> { min_stock.present? && !infinite }
  validates :current_stock, numericality: true, if: -> { current_stock.present? && !infinite }

  before_validation :clear_current_stock_if_infinite
  before_destroy :confirm_no_formula_is_associated

  # ransacker :name_or_id do |parent|
  #   Arel::Nodes::NamedFunction.new(
  #     "CAST",
  #     [ parent.table[:id].as("text") ]
  #   ).concat(parent.table[:name])
  # end
  #
  ransacker :stock_level do |parent|
    Arel.sql(
      "CASE
        WHEN infinite = TRUE THEN 100
        WHEN min_stock = 0 THEN 0
        ELSE GREATEST((current_stock / min_stock) * 100, 0)
      END"
    )
  end

  def self.ransackable_attributes(auth_object = nil)
    [ "id", "name", "stock_level", "infinite" ]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end

  scope :by_stock_level, ->(direction = :asc) {
    direction = direction.to_s.downcase == "desc" ? "DESC" : "ASC"
    order(Arel.sql(
      "CASE
        WHEN min_stock = 0 THEN 0
        ELSE GREATEST((current_stock / min_stock) * 100, 0)
      END #{direction}",
    ))
  }

  def stock_level
    return 100 if infinite?
    return 0 if min_stock.to_f.zero?
    [ (current_stock / min_stock) * 100, 0 ].max.round(2)
  end

    private

      def confirm_no_formula_is_associated
        if formulas.any?
          errors.add(:base, I18n.t(:formula_exists, scope: [ :activerecord, :errors, :models, :formula_element ]))
          throw :abort
        end
      end

      def clear_current_stock_if_infinite
        self.current_stock = nil if infinite?
      end
end

# == Schema Information
#
# Table name: formula_elements
#
#  id            :bigint           not null, primary key
#  current_stock :float            default(0.0)
#  infinite      :boolean          default(FALSE)
#  min_stock     :float            default(1.0)
#  name          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
