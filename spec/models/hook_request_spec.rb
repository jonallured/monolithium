require "rails_helper"

describe HookRequest do
  describe ".to_attrs" do
    let(:env) { {} }
    let(:request) { ActionDispatch::Request.new(env) }

    let(:parameters) { {} }
    let(:params) { ActionController::Parameters.new(parameters) }

    before do
      params.permit(:safe)
    end

    context "with a typical request" do
      let(:env) do
        rack_input = StringIO.new("typical request body")
        {"rack.input" => rack_input, "UPPER" => "typical request header"}
      end

      let(:parameters) { {safe: "typical request param"} }

      it "returns the body, headers and params from the request" do
        attrs = HookRequest.to_attrs(request, params)

        expect(attrs[:body]).to eq "typical request body"
        expect(attrs[:headers]["UPPER"]).to eq "typical request header"
        expect(attrs[:params][:safe]).to eq "typical request param"
      end
    end

    context "with a lowercase header" do
      let(:env) { {"lower" => "ignore me!"} }

      it "ignores that header" do
        attrs = HookRequest.to_attrs(request, params)
        expect(attrs[:headers].keys).to_not include "lower"
      end
    end

    context "with a header that starts with 'ROUTES'" do
      let(:env) { {"ROUTES_KEY" => "ignore me!"} }

      it "ignores that header" do
        attrs = HookRequest.to_attrs(request, params)
        expect(attrs[:headers].keys).to_not include "ROUTES_KEY"
      end
    end

    context "with a client token header" do
      let(:env) { {ApiController::CLIENT_TOKEN_HEADER => "shhh"} }

      it "redacts that header value" do
        attrs = HookRequest.to_attrs(request, params)
        expect(attrs[:headers][ApiController::CLIENT_TOKEN_HEADER]).to eq "REDACTED"
      end
    end

    context "with a param that has not been permitted" do
      let(:parameters) { {unsafe: "don't ignore me!"} }

      it "does not igore that param" do
        attrs = HookRequest.to_attrs(request, params)
        expect(attrs[:params][:unsafe]).to eq "don't ignore me!"
      end
    end

    context "with a client token param" do
      let(:parameters) { {ApiController::CLIENT_TOKEN_PARAM => "shhh"} }

      it "redacts that header value" do
        attrs = HookRequest.to_attrs(request, params)
        expect(attrs[:params][ApiController::CLIENT_TOKEN_PARAM]).to eq "REDACTED"
      end
    end
  end
end
