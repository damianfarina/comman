require 'rails_helper'

RSpec.describe "/office/clients", type: :request do
  let(:user) { create(:user) }
  let(:client) { create(:client) }

  before { sign_in user }

  describe "GET index" do
    before do
      create(:client, name: "Xavier")
      create(:client, name: "John Doe")
      create(:client, name: "Jane Smith")
    end

    it "renders a successful response" do
      create(:client)
      get office_clients_url
      expect(response).to be_successful
    end

    it "applies default sorting" do
      get office_clients_path
      parsed_response = Nokogiri::HTML(response.body)
      names = parsed_response.css("#clients > tbody > tr > td:nth-child(2) span:nth-child(2)").map(&:text)
      expect(names).to eq([ "Jane Smith", "John Doe", "Xavier" ])
    end

    it "applies search filters" do
      get office_clients_path, params: { q: { name_or_email_or_phone_or_province_or_address_cont: "Xavi" } }
      parsed_response = Nokogiri::HTML(response.body)
      names = parsed_response.css("#clients > tbody > tr > td:nth-child(2) span:nth-child(2)").map(&:text)
      expect(names).to eq([ "Xavier" ])
    end
  end
end
