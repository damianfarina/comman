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

    it "adds error to supplier_product if in-house supplier is marked for destruction" do
      in_house = create(:supplier, :in_house)
      product = create(:manufactured_productable)
      sp = product.supplier_products.create!(supplier: in_house)

      sp.mark_for_destruction
      product.valid?

      expect(sp.errors[:base]).to include("No se puede quitar el proveedor de un producto interno")
      expect(product.errors[:base]).to include("No se puede quitar el proveedor de un producto interno")
    end
  end
end
