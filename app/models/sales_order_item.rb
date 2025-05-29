class SalesOrderItem < ApplicationRecord
  include Auditable

  belongs_to :sales_order
  belongs_to :product

  enum :status, {
    quote: "quote",
    in_progress: "in_progress",
    ready: "ready",
    delivered: "delivered",
    cancelled: "cancelled",
  }

  validates :quantity, numericality: { greater_than: 0 }
  validates :unit_price, numericality: { greater_than_or_equal_to: 0 }
  validates :status, presence: true, inclusion: { in: SalesOrderItem.statuses.values }

  def audit_name
    "#{product.name} (#{quantity})"
  end
end


# == Schema Information
#
# Table name: sales_order_items
#
#  id             :bigint           not null, primary key
#  quantity       :integer
#  status         :string           default("quote"), not null
#  unit_price     :decimal(10, 2)   not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  product_id     :bigint           not null
#  sales_order_id :bigint           not null
#
# Indexes
#
#  index_sales_order_items_on_product_id      (product_id)
#  index_sales_order_items_on_sales_order_id  (sales_order_id)
#  index_sales_order_items_on_status          (status)
#
# Foreign Keys
#
#  fk_rails_...  (product_id => products.id)
#  fk_rails_...  (sales_order_id => sales_orders.id)
#
