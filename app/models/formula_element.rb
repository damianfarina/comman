class FormulaElement < ApplicationRecord
  has_many :formula_items
  has_many :formulas, -> { distinct }, through: :formula_items
  # has_many :products, -> { distinct }, through: :formulas

  validates :name, presence: true, uniqueness: true
  validates :min_stock, :current_stock, presence: true, unless: :infinite?
  validates :min_stock, numericality: { greater_than_or_equal_to: 0 }, if: -> { min_stock.present? && infinite }
  validates :current_stock, numericality: true, if: -> { current_stock.present? && infinite }

  before_validation :clear_current_stock_if_infinite

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

  # scope :missing_first, -> { order(Arel.sql("current_stock / min_stock")) }
  # scope :name_or_id_contains, lambda { |part|
  #   where("id = ? OR UPPER(name) LIKE UPPER(?)", get_id_from_search(part), "%#{part}%")
  # }

  before_destroy :confirm_no_formula_is_associated

    # self.per_page = 25

    # def join_with(elements)
    #   elements.each do |element|
    #     element.formula_items.each { |item| item.update(formula_element_id: id) }
    #     element.formula_items.reload
    #   end
    #   elements.each(&:destroy)
    #   save
    # end

    def stock_level
      return 100 if infinite?
      return 0 if min_stock.to_f.zero?
      [ (current_stock / min_stock) * 100, 0 ].max.round(2)
    end

    private

      #   def self.get_id_from_search(search)
      #     return 0 if search.blank?
      #     search = search.strip
      #     return 0 unless search.start_with?("#")
      #     search.delete("#").to_i
      #   end

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
