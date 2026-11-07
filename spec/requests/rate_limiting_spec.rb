require "rails_helper"

describe "rate limiting" do
  def stub_request_count(count)
    allow(Rails.cache).to receive(:increment).and_return(count)
  end

  describe "POST /api/v1/raw_hooks" do
    it "allows requests at the limit" do
      stub_request_count(300)

      post "/api/v1/raw_hooks", params: {}, as: :json

      expect(response.status).to eq 201
    end

    it "refuses requests over the limit" do
      stub_request_count(301)

      post "/api/v1/raw_hooks", params: {}, as: :json

      expect(response.status).to eq 429
    end

    it "does not store refused requests" do
      stub_request_count(301)

      expect { post "/api/v1/raw_hooks", params: {}, as: :json }.not_to change(RawHook, :count)
    end
  end

  describe "POST /api/v1/boops" do
    let(:params) { {boop: {foo: :bar}} }

    it "allows requests at the limit" do
      stub_request_count(30)

      post "/api/v1/boops", params: params

      expect(response.status).to eq 400
    end

    it "refuses requests over the limit" do
      stub_request_count(31)

      post "/api/v1/boops", params: params

      expect(response.status).to eq 429
    end
  end

  describe "POST /sign_in" do
    let(:password) { Monolithium.config.admin_password }

    it "allows requests at the limit" do
      stub_request_count(10)

      post "/sign_in", params: {admin_password: password}

      expect(session[:admin_password_digest]).to eq SecretCheck.digest(password)
    end

    it "does not sign in over the limit, even with the right password" do
      stub_request_count(11)

      post "/sign_in", params: {admin_password: password}

      expect(session[:admin_password_digest]).to be_nil
    end

    it "sends the request back to sign in with a message" do
      stub_request_count(11)

      post "/sign_in", params: {admin_password: password}

      expect(flash[:alert]).to eq "Too many attempts, try again later"
    end
  end

  it "does not limit other token-protected requests" do
    stub_request_count(1_000)

    get "/api/v1/check", headers: {ApiController::CLIENT_TOKEN_HEADER => Monolithium.config.client_token}

    expect(response.status).to eq 200
  end
end
