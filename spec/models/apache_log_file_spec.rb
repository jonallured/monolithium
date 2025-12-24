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

  describe "#starting_s3_key" do
    it "returns a full s3 key with dateext" do
      apache_log_file = FactoryBot.create(:apache_log_file, dateext: "20251201")
      expect(apache_log_file.starting_s3_key).to eq("domino/logs/access.log-20251201.gz")
    end
  end
end
