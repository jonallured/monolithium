require "rails_helper"

describe ApacheLogFile::Loader do
  describe "#run" do
    let(:apache_log_file) do
      FactoryBot.create(
        :apache_log_file,
        dateext: "20251201",
        parsed_entries: [parsed_entry],
        state: state
      )
    end

    let(:parsed_entry) { nil }
    let(:state) { "transformed" }

    context "with an ApacheLogFile that is not transformed" do
      let(:state) { "extracted" }

      it "raises an error" do
        expect do
          apache_log_file.loader.run
        end.to raise_error(ApacheLogFile::Loader::NotTransformedError)
      end
    end

    context "with an invalid parsed entry" do
      let(:parsed_entry) do
        {
          line_number: 1,
          raw_line: "GET /index.html",
          website: "www.example.com"
        }
      end

      it "does not create an ApacheLogItem for that entry" do
        apache_log_file.loader.run
        expect(apache_log_file.apache_log_items.count).to eq 0
        expect(apache_log_file).to be_loaded
      end
    end

    context "with a valid parsed entry" do
      let(:parsed_entry) do
        {
          line_number: 1,
          raw_line: "GET /index.html",
          website: "www.jonallured.com"
        }
      end

      it "creates an ApacheLogItem for that entry" do
        apache_log_file.loader.run
        expect(apache_log_file.apache_log_items.count).to eq 1
        expect(apache_log_file).to be_loaded
      end
    end

    context "with an ApacheLogFile that has been loaded" do
      let(:state) { "loaded" }

      it "raises an error" do
        expect do
          apache_log_file.loader.run
        end.to raise_error(ApacheLogFile::Loader::NotTransformedError)
      end
    end
  end
end
