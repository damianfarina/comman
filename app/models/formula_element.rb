class FormulaElement < ApplicationRecord
  has_many :formula_items
  has_many :formulas, through: :formula_items, uniq: true
  has_many :products, through: :formulas, uniq: true

  validates :min_stock, :current_stock, presence: true, unless: "self.infinite?"
  validates :name, presence: true, uniqueness: true
  validates :min_stock, numericality: { greater_than: 0 }, if: "self.min_stock.present? and !self.infinite?"
  validates :current_stock, numericality: true, if: "self.current_stock.blank? and !self.infinite?"

  scope :missing_first, order("current_stock / min_stock")
  scope :name_or_id_contains, lambda { |part| where("id = ? OR UPPER(name) like UPPER(?)", get_id_from_search(part), "%#{part}%") }

  before_destroy :confirm_no_formula_is_associated

  attr_accessible :name, :min_stock, :current_stock, :infinite

  self.per_page = 25

  def join_with(elements)
    elements.each do |element|
      element.formula_items.each { |item| item.update_attributes formula_element_id: self.id }
      element.formula_items(true)
    end
    elements.each { |element| element.destroy }
    self.save
  end

  def infinite?
    self.infinite
  end

  def current_stock_percentage
    return 100 if self.infinite?

    max = 100.0 * self.min_stock / 5.0
    result = self.current_stock * 100.0 / max
    result = 0 if result < 0
    result = 100 if result > 100
    result
  end

  private

    def self.get_id_from_search(search)
      return 0 if search.blank?
      search = search.strip
      return 0 if search[0] != "#"
      search.gsub("#", "").to_i
    end

    def confirm_no_formula_is_associated
      if self.formulas.any?
        errors[:base] << I18n.t(:formula_exists, scope: [ :activerecord, :errors, :models, :formula_element ])
        false
      end
    end
end

# == Schema Information
#
# Table name: formula_elements
#
#  id            :bigint           not null, primary key
#  current_stock :float            default(0.0)
#  infinite      :boolean
#  min_stock     :float            default(1.0)
#  name          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
