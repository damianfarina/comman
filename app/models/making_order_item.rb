class MakingOrderItem < ActiveRecord::Base
  belongs_to :making_order
  belongs_to :product

  validates :product_id,
    :quantity,
    :presence => true

  before_save :fill_product_fields

  attr_accessor :autocomplete_product_name

  def autocomplete_product_name
    self.product_name
  end

  def autocomplete_product_name=(value)
    self.product_name = value
  end

private

  def fill_product_fields
    self.product_name = product.name
    self.product_shape = product.shape
    self.product_size = product.size
    self.product_weight = product.weight
    self.product_pressure = product.pressure
  end

end
