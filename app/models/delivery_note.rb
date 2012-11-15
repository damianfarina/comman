class DeliveryNote < ActiveRecord::Base
  STATE_OPEN = 0
  STATE_DELIVERED = 1
  STATE_CLOSE = 2

  attr_accessible :client_id, :comments, :state

  belongs_to :client
  delegate :name, :to => :client, :prefix => true, :allow_nil => true
end
