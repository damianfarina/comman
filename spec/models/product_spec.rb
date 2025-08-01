require "rails_helper"

RSpec.describe Product, type: :model do
  describe "#stock_level" do
    let(:product) { build(:product, min_stock: 10, max_stock: 30) }

    it "returns 0 if current_stock is below or equal to min_stock" do
      product.current_stock = 5
      expect(product.stock_level).to eq(0)

      product.current_stock = 10
      expect(product.stock_level).to eq(0)
    end

    it "returns 100 if current_stock is equal or above max_stock" do
      product.current_stock = 30
      expect(product.stock_level).to eq(100)

      product.current_stock = 40
      expect(product.stock_level).to eq(100)
    end

    it "returns 50 if current_stock is exactly halfway between min and max" do
      product.current_stock = 20
      expect(product.stock_level).to eq(50)
    end

    it "returns the correct percentage otherwise" do
      product.current_stock = 15
      expect(product.stock_level).to eq(25)

      product.current_stock = 25
      expect(product.stock_level).to eq(75)
    end

    it "returns 100 if min_stock equals max_stock" do
      product.min_stock = product.max_stock = 10
      product.current_stock = 10
      expect(product.stock_level).to eq(100)
    end
  end

  describe "#decrement_stock!" do
    let(:product) { create(:purchased_productable, current_stock: 100) }

    it "decreases current_stock by the specified quantity" do
      expect { product.decrement_stock!(10) }.to change { product.current_stock }.from(100).to(90)
    end

    it "can result in negative stock" do
      product.decrement_stock!(150)
      expect(product.current_stock).to eq(-50)
    end
  end

  describe "#increment_stock!" do
    let(:product) { create(:purchased_productable, current_stock: 50) }

    it "increases current_stock by the specified quantity" do
      expect { product.increment_stock!(25) }.to change { product.current_stock }.from(50).to(75)
    end

    it "can increase stock from negative values" do
      product.update!(current_stock: -10)
      product.increment_stock!(30)
      expect(product.current_stock).to eq(20)
    end
  end

  describe "validations" do
    it "is valid with valid attributes" do
      product = build(:product, name: "ValidName", productable: build(:purchased_product))
      expect(product).to be_valid
    end

    it "is not valid without a name" do
      product = build(:product, name: nil, productable: build(:purchased_product))
      expect(product).not_to be_valid
      expect(product.errors[:name]).to include("no puede estar en blanco")
    end

    it "is not valid with a duplicate name" do
      create(:product, name: "UniqueName", productable: build(:purchased_product))
      product = build(:product, name: "UniqueName", productable: build(:purchased_product))
      expect(product).not_to be_valid
      expect(product.errors[:base]).to include(
        I18n.t(:name_must_be_unique, scope: [ :activerecord, :errors, :models, :product ], other_product_id: Product.find_by(name: "UniqueName").id, other_product_name: "UniqueName")
      )
    end

    it "adds error to supplier_product if in-house supplier is marked for destruction" do
      in_house_supplier = Supplier.in_house
      product = create(:manufactured_productable)
      sp = product.supplied_by.create!(supplier: in_house_supplier)

      sp.mark_for_destruction
      product.valid?

      expect(sp.errors[:base]).to include("No se puede quitar el proveedor de un producto interno")
      expect(product.errors[:base]).to include("No se puede quitar el proveedor de un producto interno")
    end
  end
end
