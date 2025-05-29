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

  validates :discount_percentage, numericality: { greater_than_or_equal_to: 0 }
  validates :total_price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :status, presence: true, inclusion: { in: SalesOrder.statuses.values }
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
