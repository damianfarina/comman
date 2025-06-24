require 'rails_helper'

RSpec.describe "/sales/clients", type: :request do
  let(:user) { create(:user) }

  before { sign_in user }

  describe "GET /index" do
    let!(:user1) { create(:client, name: "Xavier") }
    let!(:user2) { create(:client, name: "John Doe") }
    let!(:user3) { create(:client, name: "Jane Smith") }

    it "renders a successful response" do
      get sales_clients_url
      expect(response).to be_successful
    end

    it "points to new sales order path" do
      get sales_clients_url
      expect(response.body).to include(new_sales_sales_order_path(client_id: user1.id))
    end
  end
end
