require 'rails_helper'

RSpec.describe "/office", type: :request do
  let(:user) { create(:user) }

  before { sign_in create(:user) }

  with_versioning do
    describe "GET index" do
      before do
        PaperTrail.request.whodunnit = user.id
      end

      it "renders recent activity" do
        client = create(:client, name: "Xavier")
        supplier = create(:supplier, name: "Company")
        client.update!(name: "Client Name Updated")
        supplier.update!(name: "Supplier Name Updated")
        get office_root_url
        expect(response).to be_successful
        expect(response.body).to include(I18n.t("titles.recent_activities"))
        expect(response.body).to include(user.name)
        expect(response.body).to include("Xavier")
        expect(response.body).to include("Client Name Updated")
        expect(response.body).to include("Company")
        expect(response.body).to include("Supplier Name Updated")
        expect(response.body).to match(/#{I18n.t("paper_trail.events.create")}/i)
        expect(response.body).to match(/#{I18n.t("paper_trail.events.update")}/i)
      end
    end
  end
end
