require 'spec_helper'

describe Factory::ProductsController do

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'autocomplete'" do
    it "returns http success" do
      get 'autocomplete'
      response.status.should eql(200)
    end
  end

end
