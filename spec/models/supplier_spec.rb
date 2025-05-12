require 'rails_helper'

RSpec.describe Supplier, type: :model do
  let(:suppliers) { create_list(:supplier, 2) }

  it "should set main supplier" do
    product = create(:purchased_productable)
    product.supplied_by.create(supplier: suppliers.first)
    product.supplied_by.create(supplier: suppliers.last)
    product.save

    expect(product.main_supplier).to eq(suppliers.first)
  end

  it "should set main supplier when current is removed from suppliers list" do
    product = create(:purchased_productable)
    product.supplied_by.create(supplier: suppliers.first)
    product.supplied_by.create(supplier: suppliers.last)
    product.save

    product.supplied_by.first.mark_for_destruction
    product.save

    expect(product.supplier).to eq(suppliers.last)
    expect(product.main_supplier).to eq(suppliers.last)
  end

  it "does not allow deleting the in-house supplier" do
    in_house_supplier = Supplier.in_house
    expect { in_house_supplier.destroy }.not_to change(Supplier, :count)
    expect(in_house_supplier.errors[:base]).to include("No se puede eliminar el proveedor interno")
  end

  context "when updating the in-house supplier" do
    let(:in_house_supplier) { Supplier.in_house }

    it "adds an error to name when trying to change it" do
      in_house_supplier.name = "New Name"
      expect(in_house_supplier.save).to be_falsey
      expect(in_house_supplier.errors[:name]).to include("No se puede modificar este atributo del proveedor interno")
    end

    it "adds an error to tax_identification when trying to change it" do
      in_house_supplier.tax_identification = "67890"
      expect(in_house_supplier.save).to be_falsey
      expect(in_house_supplier.errors[:tax_identification]).to include("No se puede modificar este atributo del proveedor interno")
    end

    it "allows updating other fields" do
      in_house_supplier.update!(email: "factory@example.com")
      expect(in_house_supplier.reload.email).to eq("factory@example.com")
    end
  end
end
