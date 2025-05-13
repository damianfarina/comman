class Client < ApplicationRecord
  include HasRichComments

  enum :client_type, regular: 0, hardware_store: 2, distributor: 1
  enum :tax_type, final_consumer: 0, general_regime: 1, simplified_regime: 2

  validates :name, :client_type, :tax_identification, :tax_type, presence: true
  validates :tax_identification, uniqueness: true
  validates :tax_type, inclusion: { in: tax_types.keys }, if: :tax_type?

  def self.ransackable_attributes(auth_object = nil)
    [
      "address",
      "client_type",
      "comments_plain_text",
      "country",
      "email",
      "id",
      "name",
      "phone",
      "province",
      "seller_name",
      "tax_identification",
      "zipcode",
    ]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end

  def client_type_discount
    Discount.find_by(discount_type: :client_type, client_type: client_type)&.percentage || 0
  end
end

# == Schema Information
#
# Table name: clients
#
#  id                  :bigint           not null, primary key
#  address             :string
#  client_type         :integer          default("regular")
#  comments_plain_text :text
#  country             :string
#  email               :string
#  maps_url            :string
#  name                :string           not null
#  phone               :string
#  province            :string
#  seller_name         :string
#  tax_identification  :string           not null
#  tax_type            :integer
#  zipcode             :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_clients_on_tax_identification  (tax_identification) UNIQUE
#
