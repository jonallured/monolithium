require "rails_helper"

describe ParseCsvUploadJob do
  let(:parser_class_name) { "WellsFargoParser" }

  let(:csv_upload) do
    FactoryBot.create(:csv_upload, parser_class_name: parser_class_name)
  end

  let(:csv_upload_id) { csv_upload.id }

  context "with an invalid csv_upload_id" do
    let(:csv_upload_id) { "invalid" }

    it "exits early" do
      job = ParseCsvUploadJob.new
      expect do
        job.perform(csv_upload_id)
      end.to_not raise_error
    end
  end

  context "with a CsvUpload that has an invalid parser_class_name" do
    let(:parser_class_name) { "InvalidParser" }

    it "raises an error" do
      job = ParseCsvUploadJob.new
      expect do
        job.perform(csv_upload_id)
      end.to raise_error(NameError)
    end
  end

  context "with a valid CsvUpload" do
    it "calls the parser with that CsvUpload" do
      job = ParseCsvUploadJob.new
      expect(WellsFargoParser).to receive(:parse).with(csv_upload)
      job.perform(csv_upload_id)
    end
  end
end
