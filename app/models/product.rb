class Product < ApplicationRecord
  def self.ransackable_attributes(auth_object = nil)
    %w[id name pressure price shape size weight]
  end

  has_many :making_order_items, dependent: :destroy
  belongs_to :formula, dependent: :destroy
  delegate :name, to: :formula, prefix: true, allow_nil: true

  validates :price, :weight, presence: true, numericality: { greater_than_or_equal_to: 0 }

  def self.ransackable_associations(auth_object = nil)
    %w[formula]
  end
end

# == Schema Information
#
# Table name: products
#
#  id         :bigint           not null, primary key
#  name       :string
#  pressure   :string
#  price      :decimal(, )
#  shape      :string
#  size       :string
#  weight     :decimal(, )
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  formula_id :integer
#
