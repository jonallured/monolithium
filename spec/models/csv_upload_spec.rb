require "rails_helper"

describe CsvUpload do
  describe "validation" do
    context "without required attrs" do
      it "is invalid" do
        csv_upload = CsvUpload.new
        expect(csv_upload).to_not be_valid
      end
    end

    context "with required attrs" do
      it "is valid" do
        csv_upload = CsvUpload.new(
          data: "foo,bar,baz",
          original_filename: "dummy-data.csv",
          parser_class_name: "DummyParser"
        )

        expect(csv_upload).to be_valid
      end
    end
  end

  describe "#parsed_data" do
    let(:csv_upload) { FactoryBot.create(:csv_upload, data: data) }

    context "with data that fails to parse" do
      let(:data) { '"invalid' }

      it "returns nil" do
        expect(csv_upload.parsed_data).to eq nil
      end
    end

    context "with data that parses" do
      let(:data) { "abc,123,true" }

      it "returns that parsed data" do
        expect(csv_upload.parsed_data).to eq [["abc", "123", "true"]]
      end
    end
  end
end
