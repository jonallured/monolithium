require "rails_helper"

describe "admin session" do
  let(:password) { Monolithium.config.admin_password }

  context "after signing in" do
    before { post "/sign_in", params: {admin_password: password} }

    it "does not keep the password in the session" do
      expect(session[:admin_password]).to be_nil
    end

    it "keeps a digest of the password in the session" do
      expect(session[:admin_password_digest]).to eq SecretCheck.digest(password)
    end

    it "allows admin pages" do
      get "/dashboard"

      expect(response.status).to eq 200
    end

    it "signs out when the configured password changes" do
      allow(Monolithium.config).to receive(:admin_password).and_return("changed")

      get "/dashboard"

      expect(response).to redirect_to sign_in_path
    end
  end

  context "with the wrong password" do
    before { post "/sign_in", params: {admin_password: "wrong"} }

    it "does not set a digest" do
      expect(session[:admin_password_digest]).to be_nil
    end

    it "does not allow admin pages" do
      get "/dashboard"

      expect(response).to redirect_to sign_in_path
    end
  end

  context "when the configured password is blank" do
    before { allow(Monolithium.config).to receive(:admin_password).and_return(nil) }

    it "does not allow admin pages without signing in" do
      get "/dashboard"

      expect(response).to redirect_to sign_in_path
    end

    it "does not allow signing in without a password" do
      post "/sign_in"

      expect(session[:admin_password_digest]).to be_nil
    end
  end
end
