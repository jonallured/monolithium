require "rails_helper"

describe ApacheLogItem do
  describe "validation" do
    it "is invalid without required attrs" do
      apache_log_item = ApacheLogItem.new
      expect(apache_log_item).to be_invalid
    end

    it "is invalid without required attrs" do
      apache_log_file = FactoryBot.create(:apache_log_file)
      apache_log_item = ApacheLogItem.new(
        apache_log_file: apache_log_file,
        line_number: 1,
        raw_line: "GET /foo.html"
      )
      expect(apache_log_item).to be_valid
    end
  end
end
