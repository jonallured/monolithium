require "rails_helper"

describe ApacheLogItem do
  describe "standard validation" do
    it "is invalid without required attrs" do
      apache_log_item = ApacheLogItem.new
      expect(apache_log_item).to be_invalid
    end

    it "is valid with required attrs" do
      apache_log_file = FactoryBot.create(:apache_log_file)
      apache_log_item = ApacheLogItem.new(
        apache_log_file: apache_log_file,
        line_number: 1,
        raw_line: "GET /foo.html"
      )
      expect(apache_log_item).to be_valid
    end
  end

  describe "relevance validation" do
    let(:apache_log_item) do
      FactoryBot.build(
        :apache_log_item,
        port: port,
        request_method: request_method,
        request_params: request_params,
        request_path: request_path,
        request_user_agent: request_user_agent,
        response_status: response_status,
        website: website
      )
    end

    let(:port) { "443" }
    let(:request_method) { "GET" }
    let(:request_params) { nil }
    let(:request_path) { "/index.html" }
    let(:request_user_agent) { "Safari" }
    let(:response_status) { "200" }
    let(:website) { "www.jonallured.com" }

    context "with an irrelevant website" do
      let(:website) { "www.example.com" }

      it "is invalid" do
        expect(apache_log_item).to be_invalid
      end
    end

    context "with an irrelevant port" do
      let(:port) { "80" }

      it "is invalid" do
        expect(apache_log_item).to be_invalid
      end
    end

    context "with an irrelevant response status" do
      let(:response_status) { "500" }

      it "is invalid" do
        expect(apache_log_item).to be_invalid
      end
    end

    context "with an irrelevant request method" do
      let(:request_method) { "POST" }

      it "is invalid" do
        expect(apache_log_item).to be_invalid
      end
    end

    context "with a bot request" do
      let(:request_user_agent) { "Googlebot" }

      it "is invalid" do
        expect(apache_log_item).to be_invalid
      end
    end

    context "with a request that has params" do
      let(:request_params) { "foo=bar" }

      it "is invalid" do
        expect(apache_log_item).to be_invalid
      end
    end

    context "with an irrelevant path" do
      let(:request_path) { "/atom.xml" }

      it "is invalid" do
        expect(apache_log_item).to be_invalid
      end
    end

    context "with a relevant request" do
      it "is valid" do
        expect(apache_log_item).to be_valid
      end
    end
  end
end
