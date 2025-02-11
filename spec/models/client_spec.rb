require "rails_helper"

RSpec.describe Client, type: :model do
  describe "validations" do
    it "is invalid without a name" do
      client = build(:client, name: nil)
      expect(client).not_to be_valid
      expect(client.errors[:name]).to include("no puede estar en blanco")
    end

    it "is invalid without a client_type" do
      client = build(:client, client_type: nil)
      expect(client).not_to be_valid
      expect(client.errors[:client_type]).to include("no puede estar en blanco")
    end

    it "is invalid without a tax_identification" do
      client = build(:client, tax_identification: nil)
      expect(client).not_to be_valid
      expect(client.errors[:tax_identification]).to include("no puede estar en blanco")
    end

    it "is invalid with a duplicate tax_identification" do
      create(:client, name: "Test Client", tax_identification: "123456789")
      duplicate_client = build(:client, name: "Another Client", tax_identification: "123456789")
      expect(duplicate_client).not_to be_valid
      expect(duplicate_client.errors[:tax_identification]).to include("ya ha sido tomado")
    end
  end

  describe "#client_type_discount" do
    let(:client) { create(:client, client_type: client_type) }

    context "when there is a discount for the client type" do
      let(:client_type) { :regular }
      let!(:discount) { create(:discount, discount_type: :client_type, client_type: client_type, percentage: 10) }

      it "returns the discount percentage" do
        expect(client.client_type_discount).to eq(10)
      end
    end

    context "when there is no discount for the client type" do
      let(:client_type) { :hardware_store }

      before do
        Discount.hardware_store.destroy_all
      end

      it "returns 0" do
        expect(client.client_type_discount).to eq(0)
      end
    end
  end
end
