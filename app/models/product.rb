class Product < ApplicationRecord
  belongs_to :formula
  has_many :formula_elements, :through => :formula
  has_many :making_order_items, :dependent => :nullify

  delegate :name, :to => :formula, :prefix => true, :allow_nil => true

  scope :name_or_id_contains, lambda { |part| where('id = ? OR UPPER(name) like UPPER(?)', get_id_from_search(part), "%#{part}%") }
  scope :with_formula, lambda { |formula_id| where('formula_id = ?', formula_id) unless formula_id.blank? }

  validates :shape, :size, :pressure, :weight, :formula, :presence => true
  validate :name_is_unique, :unless => 'self.name.nil?'

  before_validation :set_name

  # self.per_page = 25

private

  def self.get_id_from_search(search)
    return 0 if search.blank?
    search = search.strip
    return 0 if search[0] != '#'
    return search.gsub('#', '').to_i
  end

  def set_name
    self.name = (self.shape + self.size + self.formula_name + self.pressure).gsub(' ', '') if self.shape.present? and
      self.size.present? and
      self.formula_name.present? and
      self.pressure.present?
  end

  def name_is_unique
    other_product = Product.find_by_name(self.name)
    errors[:base] << I18n.t(:name_must_be_unique, :scope => [:activerecord, :errors, :models, :product], :other_product_id => other_product.id, :other_product_name => other_product.name) if other_product and other_product.id != self.id
  end
end
