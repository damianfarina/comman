module Sales
  class Order::Item < ApplicationRecord
    self.table_name = "sales_order_items"

    include Auditable

    auditable_attributes only: [ :quantity, :unit_price ]

    belongs_to :order
    belongs_to :product

    enum :status, {
      quote: "quote",
      confirmed: "confirmed",
      in_progress: "in_progress",
      ready: "ready",
      delivered: "delivered",
      canceled: "canceled",
    }

    scope :confirmable, -> {
      where(status: Sales::Order::Item.statuses[:quote])
        .where.not(product_id: nil)
        .where("quantity > 0")
    }
    scope :cancelable, -> { where.not(status: Sales::Order::Item.statuses[:canceled]) }
    scope :in_progress, -> { where(status: Sales::Order::Item.statuses[:in_progress]) }
    scope :deliverable, -> {
      where(status: [
        Sales::Order::Item.statuses[:confirmed],
        Sales::Order::Item.statuses[:in_progress],
        Sales::Order::Item.statuses[:ready],
      ])
    }
    scope :ordered_by_product, -> {
      order(:product_id, :id)
    }

    validates :quantity, presence: true
    validates :quantity, numericality: { greater_than: 0 }, if: -> { quantity.present? }
    validates :unit_price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
    validates :status, presence: true, inclusion: { in: statuses.values }

    delegate :name, to: :product, prefix: true, allow_nil: true

    def split!(quantity)
      new_item = self.dup
      new_item.quantity = quantity
      new_item.status = Sales::Order::Item.statuses[:confirmed]

      if can_split? && quantity < self.quantity
        new_item.save
        self.quantity -= quantity
        self.save
      else
        errors.add(:base, :split_quantity_invalid)
        new_item.errors.add(:base, :split_quantity_invalid)
      end

      new_item
    end

    def can_split?
      quantity.to_i > 0 && [
        Sales::Order::Item.statuses[:confirmed],
        Sales::Order::Item.statuses[:in_progress],
      ].include?(status)
    end

    def subtotal
      (effective_unit_price || BigDecimal("0")) * (quantity || 0)
    end

    def effective_unit_price
      if unit_price.present?
        unit_price
      else
        current_unit_price
      end
    end

    def can_cancel?
      ![
        Sales::Order::Item.statuses[:delivered],
        Sales::Order::Item.statuses[:canceled],
      ].include?(status)
    end

    def cancel!
      unless can_cancel?
        errors.add(:base, :cancellation_failed)
        raise StandardError, "#{self.class.name} not in a cancelable state."
      end

      self.status = Sales::Order::Item.statuses[:canceled]
      save!
    end

    def can_confirm?
      status == Sales::Order::Item.statuses[:quote] &&
        product.present? &&
        quantity.to_i > 0
    end

    def confirm!
      raise StandardError, "#{self.class.name} not in a confirmable state." unless can_confirm?

      price_to_freeze = effective_unit_price
      self.unit_price = price_to_freeze || BigDecimal("0")
      self.status = Sales::Order::Item.statuses[:confirmed]

      save!
    end

    def can_deliver?
      [
        Sales::Order::Item.statuses[:confirmed],
        Sales::Order::Item.statuses[:in_progress],
        Sales::Order::Item.statuses[:ready],
      ].include?(status)
    end

    def work_on!
      raise StandardError, "#{self.class.name} not in a workable state." unless can_progress?

      self.status = Sales::Order::Item.statuses[:in_progress]

      save!
    rescue StandardError
      reload
      errors.add(:base, :in_progress_invalid)
      false
    end

    def can_progress?
      [ Sales::Order::Item.statuses[:confirmed] ].include?(status)
    end

    def complete!
      if can_complete?
        self.status = Sales::Order::Item.statuses[:ready]
        save!
      else
        reload
        errors.add(:base, :ready_invalid)
        false
      end
    end

    def can_complete?
      [ Sales::Order::Item.statuses[:in_progress] ].include?(status)
    end

    def deliver!
      if can_deliver?
        self.status = Sales::Order::Item.statuses[:delivered]
        save!
      else
        reload
        errors.add(:base, :delivery_invalid)
        false
      end
    end

    def resolved?
      delivered? || canceled?
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
end

# == Schema Information
#
# Table name: sales_order_items
#
#  id         :bigint           not null, primary key
#  quantity   :integer
#  status     :string           default("quote"), not null
#  unit_price :decimal(10, 2)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  order_id   :bigint           not null
#  product_id :bigint           not null
#
# Indexes
#
#  index_sales_order_items_on_order_id    (order_id)
#  index_sales_order_items_on_product_id  (product_id)
#  index_sales_order_items_on_status      (status)
#
# Foreign Keys
#
#  fk_rails_...  (order_id => sales_orders.id)
#  fk_rails_...  (product_id => products.id)
#
