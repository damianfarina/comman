class Client < ActiveRecord::Base
  attr_accessible :name, :address
  validates :full_name, :presence => true
end
