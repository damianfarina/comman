require 'rails_helper'

RSpec.describe "/users", type: :request do
  let(:valid_attributes) do
    {
      name: "Test User",
      email_address: "test@example.com",
    }
  end

  let(:invalid_attributes) do
    {
      name: "",
      email_address: "invalid_email",
    }
  end

  let(:user) { create(:user) }

  before { sign_in user }

  describe "GET /index" do
    it "renders a successful response" do
      User.create! valid_attributes
      get office_users_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      user = User.create! valid_attributes
      get office_user_url(user)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_office_user_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      user = User.create! valid_attributes
      get edit_office_user_url(user)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new User" do
        expect {
          post office_users_url, params: { user: valid_attributes }
        }.to change(User, :count).by(1)
      end

      it "redirects to the created user" do
        post office_users_url, params: { user: valid_attributes }
        expect(response).to redirect_to(office_user_url(User.last))
      end

      it "should create and audit log entry" do
        Auditable.with_auditing do
          post office_users_url, params: { user: valid_attributes }
        end
        audit_log = AuditLog.last
        expect(audit_log.action).to eq("create")
        expect(audit_log.auditable).to eq(User.last)
        expect(audit_log.auditable.name).to eq(valid_attributes[:name])
        expect(audit_log.auditable.email_address).to eq(valid_attributes[:email_address])
        expect(audit_log.user).to eq(user)
      end
    end

    context "with invalid parameters" do
      it "does not create a new User" do
        expect {
          post office_users_url, params: { user: invalid_attributes }
        }.to change(User, :count).by(0)
      end

      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post office_users_url, params: { user: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) do
        {
          name: "Updated User",
          email_address: "updated@example.com",
          password: "newpassword123",
          password_confirmation: "newpassword123",
        }
      end

      it "updates the requested user" do
        user = User.create! valid_attributes
        patch office_user_url(user), params: { user: new_attributes }
        user.reload
        expect(user.name).to eq("Updated User")
        expect(user.email_address).to eq("updated@example.com")
      end

      it "redirects to the user" do
        user = User.create! valid_attributes
        patch office_user_url(user), params: { user: new_attributes }
        user.reload
        expect(response).to redirect_to(office_user_url(user))
      end
    end

    context "with invalid parameters" do
      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        user = User.create! valid_attributes
        patch office_user_url(user), params: { user: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "prevents changing the password" do
        user = User.create! valid_attributes
        password_digest_before = user.password_digest
        new_attributes = {
          password: "newpassword123",
          password_confirmation: "newpassword123",
        }
        patch office_user_url(user), params: { user: new_attributes }
        user.reload
        expect(user.authenticate("newpassword123")).to be_falsey
        expect(user.password_digest).to eq(password_digest_before)
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested user" do
      user = User.create! valid_attributes
      expect {
        delete office_user_url(user)
      }.to raise_error(RuntimeError, "Users cannot be destroyed! They are part of the company history. Implement archiving instead.")
    end
  end
end
