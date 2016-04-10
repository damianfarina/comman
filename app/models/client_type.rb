class ClientType < ApplicationRecord
  validates :name, :presence => true
  has_many :clients
end
