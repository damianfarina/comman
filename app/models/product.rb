class Product < ActiveRecord::Base
  belongs_to :formula
  has_many :formula_elements, :through => :formula
  has_many :making_order_items, :dependent => :nullify

  delegate :name, :to => :formula, :prefix => true, :allow_nil => true

  scope :name_or_id_contains, lambda {|part| where('id = ? OR UPPER(name) like UPPER(?)', get_id_from_search(part), "%#{part}%") }

  validates :shape, :size, :pressure, :weight, :formula_id, :presence => true
  validates :name, :uniqueness => true

  before_validation :set_name

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
end
