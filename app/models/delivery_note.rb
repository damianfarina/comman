class DeliveryNote < ActiveRecord::Base
  STATE_OPEN = 0
  STATE_DELIVERED = 1
  STATE_CLOSE = 2

  attr_accessible :client_id, :comments, :state, :delivery_note_items_attributes

  belongs_to :client
  delegate :name, :to => :client, :prefix => true, :allow_nil => true

  has_many :delivery_note_items, :dependent => :destroy
  accepts_nested_attributes_for :delivery_note_items, :allow_destroy => true, 
    :reject_if => proc { |attrs| attrs.all? { |k, v| v.blank? } }
end
