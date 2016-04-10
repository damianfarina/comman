class DeliveryNoteItem < ApplicationRecord
  validates :quantity, :presence => true
  validates :quantity, :numericality => true, :if => 'self.quantity.present?'

  belongs_to :product
end
