module Sales
  class Order < ApplicationRecord
    self.table_name = "sales_orders"

    include Auditable, HasRichComments

    auditable only: [
      :canceled_at,
      :comments_plain_text,
      :confirmed_at,
      :client_discount_percentage,
      :cash_discount_percentage,
      :fulfilled_at,
      :status,
      :total_price,

      :client,
      :products,
      :items,
    ]

    belongs_to :client
    has_many :items, dependent: :destroy, class_name: "Sales::Order::Item"
    has_many :products, through: :items

    ransacker :status_order do
      Arel.sql(
        "CASE status " \
        "WHEN 'confirmed' THEN 1 " \
        "WHEN 'quote' THEN 2 " \
        "WHEN 'fulfilled' THEN 3 " \
        "WHEN 'canceled' THEN 4 " \
        "ELSE 5 END"
      )
    end

    ransacker :status_changed_at_order do
      Arel.sql(
        "CASE status " \
        "WHEN 'confirmed' THEN confirmed_at " \
        "WHEN 'fulfilled' THEN fulfilled_at " \
        "WHEN 'canceled' THEN canceled_at " \
        "ELSE created_at END"
      )
    end

    ransacker :products_count do
      Arel.sql(
        "(SELECT SUM(sales_order_items.quantity) " \
        "FROM sales_order_items " \
        "WHERE sales_order_items.order_id = sales_orders.id " \
        "AND sales_order_items.status != '#{Sales::Order::Item.statuses[:canceled]}')"
      )
    end

    accepts_nested_attributes_for :items, allow_destroy: true, reject_if: :all_blank

    enum :status, {
      quote: "quote",
      confirmed: "confirmed",
      fulfilled: "fulfilled",
      canceled: "canceled",
    }

    validates :client_discount_percentage, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
    validates :cash_discount_percentage, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
    validates :total_price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
    validates :status, presence: true, inclusion: { in: statuses.values }
    validates :items, presence: true

    def self.ransackable_attributes(auth_object = nil)
      %w[id comments_plain_text status_order status_changed_at_order total_price]
    end

    def self.ransackable_associations(auth_object = nil)
      %w[client]
    end

    delegate :name, to: :client, prefix: true, allow_nil: true

    after_initialize :set_default_discounts, if: :new_record?

    def editable?
      quote?
    end

    def workable?
      !editable?
    end

    def name
      "#{client_name} (#{I18n.l(status_changed_at.to_date, format: :short)})"
    end

    def status_changed_at
      canceled_at || fulfilled_at || confirmed_at || created_at
    end

    def can_confirm?
      return false unless quote?

      confirmable_items = items.confirmable
      return false if confirmable_items.empty?

      confirmable_items.all? do |item|
        effective_price = item.effective_unit_price
        effective_price.present? && effective_price >= 0
      end
    end

    def subtotal_before_order_discount
      items.sum do |item|
        if item.marked_for_destruction? ||
          item.status == Sales::Order::Item.statuses[:canceled] ||
          item.quantity.nil? ||
          item.quantity <= 0

          next BigDecimal("0")
        end

        item.subtotal
      end
    end

    def subtotal_after_order_discount
      subtotal_before_order_discount - client_discount_value
    end

    def subtotal_after_cash_discount
      subtotal_after_order_discount - cash_discount_value
    end

    def client_discount_value
      return BigDecimal("0") unless client_discount_percentage.present? && client_discount_percentage > 0

      subtotal_before_order_discount * (client_discount_percentage / BigDecimal("100.0"))
    end

    def cash_discount_value
      return BigDecimal("0") unless cash_discount_percentage.present? && cash_discount_percentage > 0

      subtotal_after_order_discount * (cash_discount_percentage / BigDecimal("100.0"))
    end

    def confirm!
      raise StandardError, I18n.t("activerecord.errors.models.sales/order.not_confirmable") unless can_confirm?

      transaction do
        self.status = Sales::Order.statuses[:confirmed]
        self.confirmed_at = Time.current

        items.confirmable.each(&:confirm!)

        self.total_price = subtotal_after_order_discount

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
      raise StandardError, I18n.t("activerecord.errors.models.sales/order.not_cancellable") unless can_cancel?

      self.status = Sales::Order.statuses[:canceled]
      self.canceled_at = Time.current
      save!
    rescue ActiveRecord::RecordInvalid, StandardError => e
      reload
      errors.add(:base, :cancellation_failed, details: e.message)
      false
    end

    def cancel_item!(item)
      item.cancel!
      self.total_price = subtotal_after_order_discount
      save!
    rescue ActiveRecord::RecordInvalid, StandardError => e
      reload
      false
    end

    def can_fulfill?
      confirmed?
    end

    def fulfill!
      raise StandardError, I18n.t("activerecord.errors.models.sales/order.not_fulfillable") unless can_fulfill?

      transaction do
        self.status = Sales::Order.statuses[:fulfilled]
        self.fulfilled_at = Time.current

        items.deliverable.each(&:deliver!)

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
end

# == Schema Information
#
# Table name: sales_orders
#
#  id                         :bigint           not null, primary key
#  canceled_at                :datetime
#  cash_discount_percentage   :decimal(5, 2)    not null
#  client_discount_percentage :decimal(5, 2)    not null
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
