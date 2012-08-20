class FormulaElement < ActiveRecord::Base
  has_many :formula_items, :dependent => :destroy
  has_many :fomulas, :through => :formula_items

  validates :min_stock, :current_stock, :presence => true, :unless => 'self.infinite?'
  validates :name, :presence => true, :uniqueness => true
  validates :min_stock, :numericality => { :greater_than => 0 }, :if => 'self.min_stock.present? and !self.infinite?'
  validates :current_stock, :numericality => true, :if => 'self.current_stock.blank? and !self.infinite?'

  scope :missing_first, order('current_stock / min_stock')

  def join_with(elements)
    elements.each do |element|
      element.formula_items.each { |item| item.update_attributes :formula_element_id => self.id}
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
end