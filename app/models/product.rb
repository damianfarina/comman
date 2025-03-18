class Product < ApplicationRecord
  include Productables

  belongs_to :formula, optional: true # This is optional until manufactured product details refactor is complete
  has_many :making_order_items, dependent: :nullify

  before_validation :set_name
  validates :name, presence: true
  validate :name_is_unique, unless: -> { name.blank? }
  validates :current_stock, :max_stock, :min_stock, numericality: { greater_than_or_equal_to: 0 }
  validates :price, presence: true, on: [ :office ]
  validates :price, numericality: { greater_than_or_equal_to: 0 }, if: -> { price.present? }

  def self.ransackable_attributes(auth_object = nil)
    %w[id name]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[formula productable]
  end

  private
    def set_name
      self.name = productable.name unless productable&.name.nil?
    end

    def name_is_unique
      other_product = Product.where.not(id: id).find_by(name: name)
      if other_product.present?
        errors.add(:base, I18n.t(:name_must_be_unique, scope: [ :activerecord, :errors, :models, :product ], other_product_id: other_product.id, other_product_name: other_product.name))
      end
    end
end

# == Schema Information
#
# Table name: products
#
#  id               :bigint           not null, primary key
#  current_stock    :integer          default(0), not null
#  description      :text
#  max_stock        :integer          default(0), not null
#  min_stock        :integer          default(0), not null
#  name             :string
#  pressure         :string
#  price            :decimal(, )
#  productable_type :string
#  shape            :string
#  size             :string
#  weight           :decimal(, )
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  formula_id       :integer
#  productable_id   :integer
#
