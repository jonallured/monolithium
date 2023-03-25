require "rails_helper"

describe MetaphysicsApi do
  describe ".generate_client" do
    context "without the required config" do
      it "returns nil" do
        client = MetaphysicsApi.generate_client
        expect(client).to be nil
      end
    end

    context "with the required config" do
      it "returns a GraphQL client" do
        allow(Monolithium.config).to receive(:metaphysics_endpoint_url)
          .and_return("https://www.example.com")
        client = MetaphysicsApi.generate_client
        expect(client).to be_a GraphQL::Client
      end
    end
  end
end
