module Product::Productables
  extend ActiveSupport::Concern

  included do
    PRODUCTABLE_TYPES = %w[ ManufacturedProduct PurchasedProduct ]

    delegated_type :productable, types: PRODUCTABLE_TYPES, dependent: :destroy
    validates_associated :productable
    accepts_nested_attributes_for :productable
  end
end
