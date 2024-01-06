require "rails_helper"

describe "POST /api/v1/raw_hooks" do
  let(:default_header_keys) do
    %w[
      CONTENT_LENGTH
      CONTENT_TYPE
      HTTPS
      HTTP_ACCEPT
      HTTP_COOKIE
      HTTP_HOST
      ORIGINAL_FULLPATH
      ORIGINAL_SCRIPT_NAME
      PATH_INFO
      QUERY_STRING
      REMOTE_ADDR
      REQUEST_METHOD
      REQUEST_URI
      SCRIPT_NAME
      SERVER_NAME
      SERVER_PORT
      SERVER_PROTOCOL
    ]
  end

  let(:default_params) do
    {
      "action" => "create",
      "controller" => "api/v1/raw_hooks"
    }
  end

  context "with empty params and headers" do
    let(:headers) { {} }
    let(:params) { {} }

    it "stores default params and headers" do
      post "/api/v1/raw_hooks", params: params, headers: headers

      expect(response.status).to be 201
      expect(RawHook.count).to eq 1

      raw_hook = RawHook.first
      expect(default_header_keys).to match_array(raw_hook.headers.keys)
      expect(raw_hook.params).to eq default_params
    end
  end

  context "with extra params and headers" do
    let(:headers) { {"X-STRING-HEADER" => "token", "X-INTEGER-HEADER" => 7} }
    let(:params) { {string_param: "password", integer_param: 11} }

    it "stores those too" do
      post "/api/v1/raw_hooks", params: params, headers: headers

      expect(response.status).to be 201
      expect(RawHook.count).to eq 1

      raw_hook = RawHook.first

      expect(raw_hook.headers["HTTP_X_STRING_HEADER"]).to eq "token"
      expect(raw_hook.headers["HTTP_X_INTEGER_HEADER"]).to eq 7

      expect(raw_hook.params["string_param"]).to eq "password"
      expect(raw_hook.params["integer_param"]).to eq "11"
    end
  end
end
