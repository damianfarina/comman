require 'rails_helper'

RSpec.describe "/office/clients", type: :request do
  let(:valid_attributes) {
    {
      name: "Client name",
      tax_identification: "987879879",
      client_type: :distributor,
    }
  }

  let(:invalid_attributes) {
    {
      name: "",
      tax_identification: "",
    }
  }

  let(:client) do
    create(
      :client,
      name: "Moises",
      tax_identification: "123456789",
      address: "123 Main St",
      zipcode: "12345",
      country: "Argentina",
      province: "Mendoza",
      maps_url: "https://maps.app.goo.gl/eFgrqGj8uBdXsgN87",
      phone: "123-456-7890",
      email: "email@email.com",
      client_type: :distributor,
    )
  end

  before { sign_in create(:user) }

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

  describe "GET /show" do
    it "renders a successful response" do
      get office_client_url(client)
      expect(response).to be_successful
    end

    it "renders attributes" do
      get office_client_url(client)
      expect(response.body).to include(client.name)
      expect(response.body).to include(client.tax_identification)
      expect(response.body).to include(I18n.translate("#{client.client_type}", scope: [ :activerecord, :attributes, :client, :client_type_values ]))
      expect(response.body).to include(client.address)
      expect(response.body).to include(client.country)
      expect(response.body).to include(client.province)
      expect(response.body).to include(client.zipcode)
      expect(response.body).to include(client.maps_url)
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      get edit_office_client_url(client)
      expect(response).to be_successful
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        {
          name: "Chang",
          tax_identification: "2020202020",
          address: "San Martín 123",
          zipcode: "5500",
          country: "Chile",
          province: "Santiago",
          maps_url: "",
          phone: "321-654-9870",
          email: "email@domain.com",
          client_type: :regular,
        }
      }

      it "updates the requested client" do
        patch office_client_url(client), params: { client: new_attributes }
        client.reload
        expect(client.name).to eq("Chang")
        expect(client.tax_identification).to eq("2020202020")
        expect(client.address).to eq("San Martín 123")
        expect(client.zipcode).to eq("5500")
        expect(client.country).to eq("Chile")
        expect(client.province).to eq("Santiago")
        expect(client.maps_url).to eq("")
        expect(client.phone).to eq("321-654-9870")
        expect(client.email).to eq("email@domain.com")
        expect(client.client_type).to eq("regular")
      end

      it "redirects to the client" do
        patch office_client_url(client), params: { client: new_attributes }
        client.reload
        expect(response).to redirect_to(office_client_url(client))
      end
    end

    context "with invalid parameters" do
      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        patch office_client_url(client), params: { client: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_office_client_url
      expect(response).to be_successful
      expect(response.body).to include(ENV.fetch("DEFAULT_COUNTRY"))
      expect(response.body).to include(ENV.fetch("DEFAULT_PROVINCE"))
      expect(response.body).to include("Particular")
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Client" do
        expect {
          post office_clients_url, params: { client: valid_attributes }
        }.to change(Client, :count).by(1)
        expect(Client.last.name).to eq("Client name")
      end

      it "redirects to the created client" do
        post office_clients_url, params: { client: valid_attributes }
        expect(response).to redirect_to(office_client_url(Client.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Client" do
        expect {
          post office_clients_url, params: { client: invalid_attributes }
        }.to change(Client, :count).by(0)
      end

      it "tries to duplicate " do
        duplicated_attributes = {
          name: "Already exists",
          tax_identification: client.tax_identification,
          client_type: :distributor,
        }
        expect {
          post office_clients_url, params: { client: duplicated_attributes }
        }.to change(Client, :count).by(0)
      end

      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post office_clients_url, params: { client: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
