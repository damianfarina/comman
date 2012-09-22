class Client < ActiveRecord::Base
  attr_accessible :full_name, :address
  validates :full_name, :presence => true
end
