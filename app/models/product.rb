class Product < ApplicationRecord
  include Productables, HasRichComments, Auditable, Coverable

  auditable only: %i[
    name
    current_stock
    max_stock
    min_stock
    price
    comments_plain_text
    supplied_by
    supplier
    cover_filename
  ]

  has_many :making_order_items, dependent: :nullify
  belongs_to :supplier, optional: true
  has_many :supplied_by, class_name: "SupplierProduct", dependent: :destroy
  has_many :suppliers, through: :supplied_by

  before_validation :set_name
  before_validation :set_supplier

  validates :name, presence: true
  validate :name_is_unique, unless: -> { name.blank? }
  validates :current_stock, :max_stock, :min_stock, numericality: true
  validates :price, presence: true, on: [ :office ]
  validates :price, numericality: { greater_than_or_equal_to: 0 }, if: -> { price.present? }
  validate :supplier_must_be_valid
  validate :no_duplicated_supplied_by
  validate :prevent_removal_of_in_house_supplier_product_for_manufactured

  accepts_nested_attributes_for :supplied_by, allow_destroy: true, reject_if: :all_blank

  def self.ransackable_attributes(auth_object = nil)
    %w[id name current_stock price created_at productable_type stock_level]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[productable suppliers]
  end

  ransacker :stock_level do |parent|
    Arel.sql(
      "CASE
        WHEN max_stock = min_stock THEN 100
        WHEN current_stock <= min_stock THEN 0
        WHEN current_stock >= max_stock THEN 100
        ELSE ROUND(((current_stock - min_stock) / NULLIF((max_stock - min_stock), 0.0)) * 100, 2)
      END"
    )
  end

  def decrement_stock!(quantity)
    self.current_stock -= quantity
    save!
  end

  def increment_stock!(quantity)
    self.current_stock += quantity
    save!
  end

  def relative_stock_level(stock_difference)
    return 100 if max_stock == min_stock
    return 0 if current_stock + stock_difference <= min_stock
    return 100 if current_stock + stock_difference >= max_stock

    ratio = (current_stock + stock_difference - min_stock).to_f / (max_stock - min_stock)
    (ratio * 100).round(2)
  end

  def stock_level
    relative_stock_level(0)
  end

  def main_supplier
    supplier || suppliers.first
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

  def set_supplier
    available_suppliers = supplied_by.reject(&:marked_for_destruction?).map(&:supplier).compact

    return if supplier.present? && available_suppliers.include?(supplier)

    first_supplier = available_suppliers.first
    self.supplier = first_supplier if first_supplier.present?
  end

  def supplier_must_be_valid
    return unless supplier_id.present?

    all_supplier_ids = supplied_by.map(&:supplier_id).compact

    unless all_supplier_ids.include?(supplier_id)
      errors.add(
        :main_supplier,
        I18n.t(:must_be_supplier, scope: [
          :activerecord, :errors, :models, :product
        ], supplier_name: supplier&.name)
      )
    end
  end

  def no_duplicated_supplied_by
    supplier_ids = supplied_by.reject(&:marked_for_destruction?).map(&:supplier_id)
    duplicate_ids = supplier_ids.select { |id| supplier_ids.count(id) > 1 }.uniq

    if duplicate_ids.any?
      supplied_by.each do |supplier_product|
        if duplicate_ids.include?(supplier_product.supplier_id) && !supplier_product.marked_for_destruction?
          supplier_product
            .errors
            .add(:base, I18n.t(:duplicated_supplied_by, scope: [ :activerecord, :errors, :models, :product ]))
        end
      end
      errors.add(:base, I18n.t(:duplicated_supplied_by, scope: [ :activerecord, :errors, :models, :product ]))
    end
  end

  def prevent_removal_of_in_house_supplier_product_for_manufactured
    return unless productable.is_a?(ManufacturedProduct)

    supplied_by.each do |sp|
      next unless sp.marked_for_destruction?
      if sp.supplier&.in_house?
        sp.errors.add(:base, I18n.t(:manufactured_in_house, scope: [ :activerecord, :errors, :models, :product ]))
        errors.add(:base, I18n.t(:manufactured_in_house, scope: [ :activerecord, :errors, :models, :product ]))
      end
    end
  end
end

# == Schema Information
#
# Table name: products
#
#  id                  :bigint           not null, primary key
#  comments_plain_text :text
#  current_stock       :integer          default(0), not null
#  max_stock           :integer          default(0), not null
#  min_stock           :integer          default(0), not null
#  name                :string
#  price               :decimal(10, 2)   default(0.0), not null
#  productable_type    :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  productable_id      :integer
#  supplier_id         :bigint
#
# Indexes
#
#  index_products_on_productable_type_and_productable_id  (productable_type,productable_id)
#  index_products_on_supplier_id                          (supplier_id)
#
# Foreign Keys
#
#  fk_rails_...  (supplier_id => suppliers.id)
#
