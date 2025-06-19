class SalesOrder < ApplicationRecord
  include Auditable, HasRichComments

  auditable only: [
    :cancelled_at,
    :comments_plain_text,
    :confirmed_at,
    :client_discount_percentage,
    :cash_discount_percentage,
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

  validates :client_discount_percentage, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :cash_discount_percentage, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :total_price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :status, presence: true, inclusion: { in: statuses.values }

  def self.ransackable_attributes(auth_object = nil)
    %w[id comments_plain_text]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[client]
  end

  delegate :name, to: :client, prefix: true

  after_initialize :set_default_discounts, if: :new_record?

  def editable?
    quote?
  end

  def can_confirm?
    return false unless quote?

    confirmable_items = sales_order_items.confirmable
    return false if confirmable_items.empty?

    confirmable_items.all? do |item|
      effective_price = item.effective_unit_price
      effective_price.present? && effective_price >= 0
    end
  end

  def confirm!
    raise StandardError, I18n.t("activerecord.errors.models.sales_order.not_confirmable") unless can_confirm?

    transaction do
      self.status = SalesOrder.statuses[:confirmed]
      self.confirmed_at = Time.current

      sales_order_items.confirmable.each(&:confirm!)

      subtotal_before_order_discount = sales_order_items.reload.in_progress.sum(&:subtotal)

      client_discount_value = BigDecimal("0")
      if self.client_discount_percentage.present? && self.client_discount_percentage > 0
        client_discount_value = subtotal_before_order_discount * (self.client_discount_percentage / BigDecimal("100.0"))
      end

      self.total_price = subtotal_before_order_discount - client_discount_value

      save!
    end
  rescue ActiveRecord::RecordInvalid, StandardError => e
    reload
    errors.add(:base, :confirmation_failed, details: e.message)
    false
  end

  def final_price_with_cash_discount
    return total_price unless confirmed? || fulfilled?
    return total_price if cash_discount_percentage <= 0

    cash_discount_value = self.total_price * (self.cash_discount_percentage / BigDecimal("100.0"))
    self.total_price - cash_discount_value
  end

  def can_cancel?
    quote? || confirmed?
  end

  def cancel!
    raise StandardError, I18n.t("activerecord.errors.models.sales_order.not_cancellable") unless can_cancel?

    self.status = SalesOrder.statuses[:cancelled]
    self.cancelled_at = Time.current
    save!
  rescue ActiveRecord::RecordInvalid, StandardError => e
    reload
    errors.add(:base, :cancellation_failed, details: e.message)
    false
  end

  def can_fulfill?
    confirmed?
  end

  def fulfill!
    raise StandardError, I18n.t("activerecord.errors.models.sales_order.not_fulfillable") unless can_fulfill?

    transaction do
      self.status = SalesOrder.statuses[:fulfilled]
      self.fulfilled_at = Time.current

      sales_order_items.deliverable.each(&:deliver!)

      save!
    end
  rescue ActiveRecord::RecordInvalid, StandardError => e
    reload
    errors.add(:base, :fulfillment_failed, details: e.message)
    false
  end

  private

  def set_default_discounts
    if self.client_discount_percentage.blank?
      self.client_discount_percentage = client&.client_type_discount || 0
    end

    if self.cash_discount_percentage.blank?
      self.cash_discount_percentage = Discount.cash_discount.percentage
    end
  end
end

# == Schema Information
#
# Table name: sales_orders
#
#  id                         :bigint           not null, primary key
#  cancelled_at               :datetime
#  cash_discount_percentage   :decimal(5, 2)    default(0.0), not null
#  client_discount_percentage :decimal(5, 2)    default(0.0), not null
#  comments_plain_text        :text
#  confirmed_at               :datetime
#  fulfilled_at               :datetime
#  status                     :string           default("quote"), not null
#  total_price                :decimal(12, 2)
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  client_id                  :bigint           not null
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
