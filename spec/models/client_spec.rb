require "rails_helper"

RSpec.describe Client, type: :model do
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
