class DeliveryNoteItem < ActiveRecord::Base
  attr_accessible :delivery_note_id, :product_id, :quantity
end
