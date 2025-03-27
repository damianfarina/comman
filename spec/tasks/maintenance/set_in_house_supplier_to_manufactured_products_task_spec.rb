# frozen_string_literal: true

require "rails_helper"

module Maintenance
  RSpec.describe SetInHouseSupplierToManufacturedProductsTask do
    describe "#process" do
      let!(:in_house_supplier) { create(:supplier, :in_house) }
      let(:manufactured_product) { create(:manufactured_productable) }

      it "sets the in house supplier if not present" do
        expect(manufactured_product.suppliers.count).to eq(0)
        described_class.process(manufactured_product)
        expect(manufactured_product.reload.suppliers.count).to eq(1)
      end

      it "skips if in house supplier is present" do
        manufactured_product.supplier_products.create!(supplier: in_house_supplier)
        manufactured_product.supplier_products.create!(supplier: create(:supplier))
        expect(manufactured_product.suppliers.count).to eq(2)
        described_class.process(manufactured_product)
        expect(manufactured_product.reload.suppliers.count).to eq(2)
      end

      it "skips if the product is purchased" do
        purchased_product = create(:purchased_productable)

        expect(purchased_product.suppliers.count).to eq(0)
        described_class.process(purchased_product)
        expect(purchased_product.reload.suppliers.count).to eq(0)
      end
    end
  end
end
