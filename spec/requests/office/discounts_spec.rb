require 'rails_helper'

RSpec.describe "/office/discounts", type: :request do
  before { sign_in create(:user) }

  describe "GET /show" do
    let(:discount) { Discount.regular.first }

    it "renders a successful response" do
      get office_discount_url(discount)
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    let(:discount) { Discount.distributor.first }

    it "renders a successful response" do
      get edit_office_discount_url(discount)
      expect(response).to be_successful
    end
  end

  describe "PATCH /update" do
    let(:discount) { Discount.cash.first }

    context "with valid parameters" do
      let(:new_attributes) do
        {
          percentage: 20.0,
        }
      end

      it "updates the requested product" do
        expect(discount.percentage).to eq(5.0)
        patch office_discount_url(discount), params: { discount: new_attributes }
        discount.reload
        expect(discount.percentage).to eq(20.0)
      end

      it "redirects to the discount" do
        patch office_discount_url(discount), params: { discount: new_attributes }
        discount.reload
        expect(response).to redirect_to(office_discount_url(discount))
      end
    end

    context "with invalid parameters" do
      let(:invalid_attributes) do
        {
          percentage: 120.0,
        }
      end

      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        patch office_discount_url(discount), params: { discount: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
