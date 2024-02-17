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
end
