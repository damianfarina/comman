require 'spec_helper'

describe Client do
  it 'has a valid factory' do
    FactoryGirl.create(:client).should be_valid
  end
  it 'is invalid without a name' do
    FactoryGirl.build(:client, name: nil).should_not be_valid
  end
  it 'is invalid without an address' do
    FactoryGirl.build(:client, address: nil).should_not be_valid
  end
  it 'is invalid without a zip code' do
    FactoryGirl.build(:client, zip_code: nil).should_not be_valid
  end
  it 'is invalid without a balance' do
    FactoryGirl.build(:client, balance: nil).should_not be_valid
  end
  it 'is invalid without an admission date' do
    FactoryGirl.build(:client, admission_date: nil).should_not be_valid
  end
  it 'is invalid without a type' do
    FactoryGirl.build(:client, client_type: nil).should_not be_valid
  end

  it "returns a sorted array of results that match" do
    smith = FactoryGirl.create(:client, name: "Smith")
    jones = FactoryGirl.create(:client, name: "Jones")
    johnson = FactoryGirl.create(:client, name: "Johnson")
    Client.name_or_id_contains("J").should == [johnson, jones]
  end
end