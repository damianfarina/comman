require 'rails_helper'

RSpec.describe Supplier, type: :model do
  let(:suppliers) { create_list(:supplier, 2) }

  it "should set main supplier" do
    product = create(:purchased_productable)
    product.supplier_products.create(supplier: suppliers.first)
    product.supplier_products.create(supplier: suppliers.last)
    product.save

    expect(product.main_supplier).to eq(suppliers.first)
  end

  it "should set main supplier when current is removed from suppliers list" do
    product = create(:purchased_productable)
    product.supplier_products.create(supplier: suppliers.first)
    product.supplier_products.create(supplier: suppliers.last)
    product.save

    product.supplier_products.first.mark_for_destruction
    product.save

    expect(product.supplier).to eq(suppliers.last)
    expect(product.main_supplier).to eq(suppliers.last)
  end
end
