class MakingOrderItem < ApplicationRecord
  belongs_to :making_order
  belongs_to :product

  validates :quantity, presence: true

  before_validation :prepare_product_fields, if: -> { product_id.present? }

  private
    def prepare_product_fields
      self.product_name = product.name
      self.product_shape = product.productable.shape
      self.product_pressure = product.productable.pressure
      self.product_size = product.productable.size
      self.product_weight = product.productable.weight
    end
end

# == Schema Information
#
# Table name: making_order_items
#
#  id               :bigint           not null, primary key
#  product_name     :string
#  product_pressure :string
#  product_shape    :string
#  product_size     :string
#  product_weight   :decimal(, )
#  quantity         :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  making_order_id  :integer
#  product_id       :integer
#
