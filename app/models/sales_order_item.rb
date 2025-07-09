class SalesOrderItem < ApplicationRecord
  include Auditable

  auditable_attributes only: [ :quantity, :unit_price ]

  belongs_to :sales_order
  belongs_to :product

  enum :status, {
    quote: "quote",
    in_progress: "in_progress",
    ready: "ready",
    delivered: "delivered",
    cancelled: "cancelled",
  }

  scope :confirmable, -> {
    where(status: SalesOrderItem.statuses[:quote])
      .where.not(product_id: nil)
      .where("quantity > 0")
  }
  scope :in_progress, -> { where(status: SalesOrderItem.statuses[:in_progress]) }
  scope :deliverable, -> {
    where(status: [
      SalesOrderItem.statuses[:in_progress],
      SalesOrderItem.statuses[:ready],
    ])
  }

  validates :quantity, numericality: { greater_than: 0 }, allow_nil: true
  validates :unit_price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :status, presence: true, inclusion: { in: statuses.values }

  def subtotal
    (effective_unit_price || BigDecimal("0")) * (quantity || 0)
  end

  def effective_unit_price
    if unit_price.present?
      unit_price
    else
      product&.price
    end
  end

  def can_confirm?
    status == SalesOrderItem.statuses[:quote] &&
      product.present? &&
      quantity.to_i > 0
  end

  def confirm!
    raise StandardError, "SalesOrderItem not in a confirmable state." unless can_confirm?

    price_to_freeze = effective_unit_price
    self.unit_price = price_to_freeze || BigDecimal("0")
    self.status = SalesOrderItem.statuses[:in_progress]

    save!
  end

  def can_deliver?
    [
      SalesOrderItem.statuses[:in_progress],
      SalesOrderItem.statuses[:ready],
    ].include?(status)
  end

  def deliver!
    raise StandardError, "SalesOrderItem cannot be delivered in its current state." unless can_deliver?

    self.status = SalesOrderItem.statuses[:delivered]
    save!
  end

  def resolved?
    delivered? || cancelled?
  end

  def current_unit_price
    product&.price
  end

  def audit_name
    product_name = product&.name || "N/A"
    item_quantity = quantity || 0
    "#{product_name} (#{item_quantity})"
  end
end

# == Schema Information
#
# Table name: sales_order_items
#
#  id             :bigint           not null, primary key
#  quantity       :integer
#  status         :string           default("quote"), not null
#  unit_price     :decimal(10, 2)
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
