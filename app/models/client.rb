class Client < ActiveRecord::Base
  attr_accessible :name, :address
  validates :name, :address, :presence => true
end
