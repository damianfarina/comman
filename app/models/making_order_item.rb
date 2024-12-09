class MakingOrderItem < ApplicationRecord
  belongs_to :making_order
  belongs_to :product
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
