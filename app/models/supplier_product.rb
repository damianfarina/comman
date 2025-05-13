class SupplierProduct < ApplicationRecord
  include Auditable

  has_rich_text :comments

  belongs_to :supplier
  belongs_to :product

  validates :price, numericality: { greater_than: 0 }, if: -> { price.present? }
  validates :code, uniqueness: { scope: :supplier_id }, allow_nil: true, if: -> { code.present? }

  delegate :name, to: :supplier, prefix: true, allow_nil: true
  delegate :name, to: :product, prefix: true, allow_nil: true

  auditable_attributes only: [ :code, :price ]

  def audit_name
    details = [ code, price ].compact
    suffix = details.any? ? " (#{details.join(' - ')})" : ""
    "#{supplier_name}#{suffix}"
  end
end

# == Schema Information
#
# Table name: supplier_products
#
#  id          :bigint           not null, primary key
#  code        :string
#  price       :decimal(10, 2)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  product_id  :bigint           not null
#  supplier_id :bigint           not null
#
# Indexes
#
#  index_supplier_products_on_product_id   (product_id)
#  index_supplier_products_on_supplier_id  (supplier_id)
#
# Foreign Keys
#
#  fk_rails_...  (product_id => products.id)
#  fk_rails_...  (supplier_id => suppliers.id)
#
