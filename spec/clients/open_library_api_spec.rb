require "rails_helper"

describe OpenLibraryApi do
  describe ".generate_client" do
    context "without the required config" do
      it "returns nil" do
        client = OpenLibraryApi.generate_client
        expect(client).to be nil
      end
    end

    context "with the required config" do
      it "returns a Faraday connection" do
        allow(Monolithium.config).to receive(:open_library_endpoint_url)
          .and_return("https://www.example.com")
        client = OpenLibraryApi.generate_client
        expect(client).to be_a Faraday::Connection
      end
    end
  end
end
