require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      product = build(:product, name: 'ValidName', productable: build(:purchased_product))
      expect(product).to be_valid
    end

    it 'is not valid without a name' do
      product = build(:product, name: nil, productable: build(:purchased_product))
      expect(product).not_to be_valid
      expect(product.errors[:name]).to include("no puede estar en blanco")
    end

    it 'is not valid with a duplicate name' do
      create(:product, name: 'UniqueName', productable: build(:purchased_product))
      product = build(:product, name: 'UniqueName', productable: build(:purchased_product))
      expect(product).not_to be_valid
      expect(product.errors[:base]).to include(I18n.t(:name_must_be_unique, scope: [ :activerecord, :errors, :models, :product ], other_product_id: Product.find_by(name: 'UniqueName').id, other_product_name: 'UniqueName'))
    end
  end
end
