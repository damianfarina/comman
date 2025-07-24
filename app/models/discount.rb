class Discount < ApplicationRecord
  enum :discount_type, client_type: 0, cash: 1
  enum :client_type, Client.client_types, instance_methods: false

  validates :discount_type, presence: true
  validates :percentage, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }

  def self.cash_discount
    find_by(discount_type: :cash)
  end
end

# == Schema Information
#
# Table name: discounts
#
#  id            :bigint           not null, primary key
#  client_type   :integer
#  discount_type :integer          not null
#  percentage    :decimal(5, 2)    default(0.0), not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_discounts_on_client_type    (client_type)
#  index_discounts_on_discount_type  (discount_type)
#
