require 'rails_helper'

RSpec.describe "/office/suppliers", type: :request do
  let(:invalid_attributes) do
    {
      name: nil,
      address: "Address 1",
      bank_account_number: "Bank Account Number 1",
      bank_name: "Bank Name 1",
      email: "malomalo.com",
    }
  end

  let(:user) { create(:user) }

  before { sign_in user }

  describe "GET /index" do
    it "renders a successful response" do
      create(:supplier)
      get office_suppliers_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      supplier = create(:supplier)
      get office_supplier_url(supplier)
      expect(response).to be_successful
    end

    context "tracking supplier changes" do
      with_versioning do
        it "displays recent activities" do
          PaperTrail.request.whodunnit = user.id
          supplier = create(:supplier, name: "Original Supplier Name", phone: "100123")
          supplier.update!(name: "Updated Supplier Name", phone: "987654321")

          get office_supplier_url(supplier)

          expect(response.body).to include(I18n.t("titles.recent_activities"))
          expect(response.body).to include(user.name)
          expect(response.body).to include("100123")
          expect(response.body).to include("Original Supplier Name")
          expect(response.body).to include("Updated Supplier Name")
          expect(response.body).to match(/#{I18n.t("paper_trail.events.create")}/i)
          expect(response.body).to match(/#{I18n.t("paper_trail.events.update")}/i)
        end
      end
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_office_supplier_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      supplier = create(:supplier)
      get edit_office_supplier_url(supplier)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Supplier" do
        expect {
          post office_suppliers_url, params: { supplier: attributes_for(:supplier) }
        }.to change(Supplier, :count).by(1)
      end

      it "redirects to the created supplier" do
        post office_suppliers_url, params: { supplier: attributes_for(:supplier) }
        expect(response).to redirect_to(office_supplier_url(Supplier.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Supplier" do
        expect {
          post office_suppliers_url, params: { supplier: invalid_attributes }
        }.to change(Supplier, :count).by(0)
      end

      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post office_suppliers_url, params: { supplier: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) do
        {
          address: "New Address",
          bank_account_number: "New Bank Account Number",
          bank_name: "New Bank Name",
          comments: "New Comments",
          country: "New Country",
          email: "email22@company.com",
          maps_url: "New Maps URL",
          name: "New Name",
          phone: "New Phone",
          province: "New Province",
          routing_number: "New Routing Number",
          tax_identification: "New Tax Identification",
          tax_type: "exempt",
          zipcode: "New Zipcode",
        }
      end

      it "updates the requested supplier" do
        supplier = create(:supplier)
        patch office_supplier_url(supplier), params: { supplier: new_attributes }
        supplier.reload
        expect(supplier.address).to eq("New Address")
        expect(supplier.bank_account_number).to eq("New Bank Account Number")
        expect(supplier.bank_name).to eq("New Bank Name")
        expect(supplier.comments.to_plain_text).to eq("New Comments")
        expect(supplier.comments_plain_text).to eq("New Comments")
        expect(supplier.country).to eq("New Country")
        expect(supplier.email).to eq("email22@company.com")
        expect(supplier.maps_url).to eq("New Maps URL")
        expect(supplier.name).to eq("New Name")
        expect(supplier.phone).to eq("New Phone")
        expect(supplier.province).to eq("New Province")
        expect(supplier.routing_number).to eq("New Routing Number")
        expect(supplier.tax_identification).to eq("New Tax Identification")
        expect(supplier.tax_type).to eq("exempt")
        expect(supplier.zipcode).to eq("New Zipcode")
      end

      it "redirects to the supplier" do
        supplier = create(:supplier)
        patch office_supplier_url(supplier), params: { supplier: new_attributes }
        supplier.reload
        expect(response).to redirect_to(office_supplier_url(supplier))
      end
    end

    context "with invalid parameters" do
      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        supplier = create(:supplier)
        patch office_supplier_url(supplier), params: { supplier: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested supplier" do
      supplier = create(:supplier)
      expect {
        delete office_supplier_url(supplier)
      }.to change(Supplier, :count).by(-1)
    end

    it "redirects to the suppliers list" do
      supplier = create(:supplier)
      delete office_supplier_url(supplier)
      expect(response).to redirect_to(office_suppliers_url)
    end
  end
end
