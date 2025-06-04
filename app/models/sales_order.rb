class SalesOrder < ApplicationRecord
  include Auditable, HasRichComments

  auditable only: [
    :cancelled_at,
    :comments_plain_text,
    :confirmed_at,
    :discount_percentage,
    :fulfilled_at,
    :status,
    :total_price,

    :client,
    :products,
    :sales_order_items,
  ]

  belongs_to :client
  has_many :sales_order_items, dependent: :destroy
  has_many :products, through: :sales_order_items

  enum :status, {
    quote: "quote",
    confirmed: "confirmed",
    fulfilled: "fulfilled",
    cancelled: "cancelled",
  }

  validates :discount_percentage, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :total_price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :status, presence: true, inclusion: { in: statuses.values }

  def editable?
    quote?
  end

  def can_confirm?
    return false unless quote?

    confirmable_items = sales_order_items.confirmable
    return false if confirmable_items.empty?

    confirmable_items.all? do |item|
      effective_price = item.effective_unit_price
      effective_price.present? && effective_price >= BigDecimal('0')
      # item.quantity.to_i > 0 and item.product.present? are checked by the :confirmable scope
    end
  end

  def confirm!
    raise StandardError, "SalesOrder cannot be confirmed in its current state or items are not valid." unless can_confirm?

    transaction do
      self.status = SalesOrder.statuses[:confirmed]
      self.confirmed_at = Time.current

      sales_order_items.confirmable.each(&:confirm!)

      # Sum subtotals only from items that were successfully confirmed and are now 'in_progress'
      subtotal_before_order_discount = sales_order_items.reload.where(status: SalesOrderItem.statuses[:in_progress]).sum(&:subtotal)

      order_discount_value = BigDecimal('0')
      if self.discount_percentage.present? && self.discount_percentage > BigDecimal('0')
        order_discount_value = subtotal_before_order_discount * (self.discount_percentage / BigDecimal('100.0'))
      end

      self.total_price = subtotal_before_order_discount - order_discount_value

      save!
    end
  rescue ActiveRecord::RecordInvalid, StandardError => e
    errors.add(:base, "Failed to confirm order: #{e.message}")
    false
  end

  def can_cancel?
    quote? || confirmed?
  end

  def cancel!
    raise StandardError, "Order cannot be cancelled in its current state." unless can_cancel?

    self.status = SalesOrder.statuses[:cancelled]
    self.cancelled_at = Time.current
    save!
  rescue ActiveRecord::RecordInvalid, StandardError => e
    errors.add(:base, "Failed to cancel order: #{e.message}")
    false
  end

  def can_fulfill?
    confirmed?
  end

  def fulfill!
    raise StandardError, "Order cannot be fulfilled in its current state." unless can_fulfill?

    transaction do
      self.status = SalesOrder.statuses[:fulfilled]
      self.fulfilled_at = Time.current

      sales_order_items.where(status: [SalesOrderItem.statuses[:in_progress], SalesOrderItem.statuses[:ready]]).find_each do |item|
        item.status = SalesOrderItem.statuses[:delivered]
        item.save!
      end

      save!
    end
  rescue ActiveRecord::RecordInvalid, StandardError => e
    errors.add(:base, "Failed to fulfill order: #{e.message}")
    false
  end
end

# == Schema Information
#
# Table name: sales_orders
#
#  id                  :bigint           not null, primary key
#  cancelled_at        :datetime
#  comments_plain_text :text
#  confirmed_at        :datetime
#  discount_percentage :decimal(5, 2)    default(0.0), not null
#  fulfilled_at        :datetime
#  status              :string           default("quote"), not null
#  total_price         :decimal(12, 2)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  client_id           :bigint           not null
#
# Indexes
#
#  index_sales_orders_on_client_id  (client_id)
#  index_sales_orders_on_status     (status)
#
# Foreign Keys
#
#  fk_rails_...  (client_id => clients.id)
#
