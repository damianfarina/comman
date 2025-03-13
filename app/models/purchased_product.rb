class PurchasedProduct < ApplicationRecord
  include Productable

  def name
    nil
  end
end

# == Schema Information
#
# Table name: purchased_products
#
#  id         :bigint           not null, primary key
#  base_cost  :decimal(, )
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
