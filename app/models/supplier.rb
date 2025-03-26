class Supplier < ApplicationRecord
  include HasRichComments

  enum :tax_type, general_regime: 0, simplified_regime: 1, exempt: 2

  has_many :supplier_products, dependent: :destroy
  has_many :purchased_products, through: :supplier_products
  has_many :active_products, class_name: "Product", foreign_key: "supplier_id", dependent: :nullify


  validates :name, :tax_identification, :phone, :email, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, :tax_identification, uniqueness: true
  validates :tax_type, inclusion: { in: tax_types.keys }
  validates :in_house, uniqueness: true, if: :in_house?

  def self.ransackable_attributes(auth_object = nil)
    [
      "id",
      "address",
      "bank_account_number",
      "bank_name",
      "comments_plain_text",
      "country",
      "email",
      "name",
      "phone",
      "province",
      "routing_number",
      "tax_identification",
      "zipcode",
    ]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end
end

# == Schema Information
#
# Table name: suppliers
#
#  id                  :bigint           not null, primary key
#  address             :string
#  bank_account_number :string
#  bank_name           :string
#  comments_plain_text :text
#  country             :string
#  email               :string
#  in_house            :boolean
#  maps_url            :string
#  name                :string           not null
#  phone               :string
#  province            :string
#  routing_number      :string
#  tax_identification  :string           not null
#  tax_type            :integer          default("general_regime")
#  zipcode             :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_suppliers_on_tax_identification  (tax_identification) UNIQUE
#
