require "rails_helper"

RSpec.describe Client, type: :model do
  it "is invalid without a name" do
    client = Client.new(name: nil)
    expect(client).not_to be_valid
    expect(client.errors[:name]).to include("no puede estar en blanco")
  end

  it "is invalid without a tax_identification" do
    client = Client.new(tax_identification: nil)
    expect(client).not_to be_valid
    expect(client.errors[:tax_identification]).to include("no puede estar en blanco")
  end

  it "is invalid with a duplicate tax_identification" do
    Client.create!(name: "Test Client", tax_identification: "123456789")
    duplicate_client = Client.new(name: "Another Client", tax_identification: "123456789")
    expect(duplicate_client).not_to be_valid
    expect(duplicate_client.errors[:tax_identification]).to include("ya ha sido tomado")
  end
end
