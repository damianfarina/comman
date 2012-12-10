class DeliveryNoteItem < ActiveRecord::Base
  attr_accessible :delivery_note_id, :product_id, :quantity

  validates :quantity, :presence => true
  validates :quantity, :numericality => true, :if => 'self.quantity.present?'

  belongs_to :product
end
