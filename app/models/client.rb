class Client < ApplicationRecord
  enum :client_type, regular: 0, distributor: 1

  def self.ransackable_attributes(auth_object = nil)
    [ "id", "address", "client_type", "country", "email", "maps_url", "name", "phone", "province", "tax_identification", "zipcode" ]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end
end

# == Schema Information
#
# Table name: clients
#
#  id                 :bigint           not null, primary key
#  address            :string
#  client_type        :integer          default(0)
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
