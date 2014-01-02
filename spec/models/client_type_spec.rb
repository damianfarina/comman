require 'spec_helper'

describe ClientType do
  it 'is invalid without a name' do
    FactoryGirl.build(:client_type, name: nil).should_not be_valid
  end
end
