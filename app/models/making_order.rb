class MakingOrder < ApplicationRecord
  has_one :making_order_formula, dependent: :destroy
  has_many :making_order_items, dependent: :destroy
  has_many :making_order_formula_items, through: :making_order_formula

  def self.ransackable_associations(auth_object = nil)
    []
  end

  def self.ransackable_attributes(auth_object = nil)
    [ "id", "comments" ]
  end
end

# == Schema Information
#
# Table name: making_orders
#
#  id               :bigint           not null, primary key
#  comments         :text
#  mixer_capacity   :float
#  rounds_count     :integer
#  state            :integer
#  total_weight     :decimal(, )
#  weight_per_round :decimal(, )
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
