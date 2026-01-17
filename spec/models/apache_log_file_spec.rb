require "rails_helper"

describe ApacheLogFile do
  describe "destruction" do
    it "destroys associated ApacheLogItem records" do
      apache_log_file = FactoryBot.create(:apache_log_file)
      FactoryBot.create(:apache_log_item, apache_log_file: apache_log_file)
      apache_log_file.destroy
      expect(ApacheLogFile.count).to eq 0
      expect(ApacheLogItem.count).to eq 0
    end
  end

  describe "validation" do
    it "is invalid without required attrs" do
      apache_log_file = ApacheLogFile.new
      expect(apache_log_file).to be_invalid
    end

    it "is valid with required attrs" do
      apache_log_file = ApacheLogFile.new(
        dateext: "20251201",
        state: "pending"
      )
      expect(apache_log_file).to be_valid
    end
  end

  describe "#s3_keys" do
    it "returns s3 keys with dateext" do
      apache_log_file = FactoryBot.create(:apache_log_file, dateext: "20251201")
      expect(apache_log_file.s3_keys).to eq({
        access_log: "domino/logs/access.log-20251201.gz",
        error_log: "domino/logs/error.log-20251201.gz"
      })
    end
  end

  describe ".import" do
    it "runs the ETL pipeline" do
      expect(S3Api).to receive(:read).with("domino/logs/access.log-20251201.gz").and_return("binary-data")
      raw_lines = 'www.jonallured.com:443 1.1.1.1 - - [01/Dec/2025:00:00:00 +0000] "GET / HTTP/1.0" 200 1 "-" "-"'
      expect(Zlib).to receive(:gunzip).with("binary-data").and_return(raw_lines)

      apache_log_file = ApacheLogFile.import("20251201")
      expect(apache_log_file).to be_loaded

      apache_log_item = apache_log_file.apache_log_items.first
      expect(apache_log_item.browser_name).to eq "Unknown Browser"
      expect(apache_log_item.port).to eq "443"
      expect(apache_log_item.referrer_host).to eq "-"
      expect(apache_log_item.remote_ip_address).to eq "1.1.1.1"
      expect(apache_log_item.remote_logname).to eq "-"
      expect(apache_log_item.remote_user).to eq "-"
      expect(apache_log_item.request_method).to eq "GET"
      expect(apache_log_item.request_params).to be_nil
      expect(apache_log_item.request_path).to eq "/index.html"
      expect(apache_log_item.request_protocol).to eq "HTTP/1.0"
      expect(apache_log_item.request_referrer).to eq "-"
      expect(apache_log_item.request_user_agent).to eq "-"
      expect(apache_log_item.requested_at).to eq Time.new(2025, 12, 1, 0, 0, 0, 0).in_time_zone
      expect(apache_log_item.response_size).to eq 1
      expect(apache_log_item.response_status).to eq "200"
      expect(apache_log_item.website).to eq "www.jonallured.com"
    end
  end
end
