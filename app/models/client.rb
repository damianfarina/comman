class Client < ApplicationRecord
  enum :client_type, regular: 0, hardware_store: 2, distributor: 1

  validates :name, presence: true
  validates :client_type, presence: true
  validates :tax_identification, presence: true, uniqueness: true

  def self.ransackable_attributes(auth_object = nil)
    [ "id", "address", "client_type", "country", "email", "maps_url", "name", "phone", "province", "tax_identification", "zipcode" ]
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
#  id                 :bigint           not null, primary key
#  address            :string
#  client_type        :integer          default("regular")
#  country            :string
#  email              :string
#  maps_url           :string
#  name               :string           not null
#  phone              :string
#  province           :string
#  tax_identification :string           not null
#  zipcode            :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
