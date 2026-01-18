require "rails_helper"

describe ApacheLogFile::Extractor do
  describe "#run" do
    let(:apache_log_file) do
      FactoryBot.create(
        :apache_log_file,
        dateext: "20251201",
        raw_lines: nil,
        state: state
      )
    end

    context "with an ApacheLogFile record that is pending" do
      let(:state) { "pending" }

      it "downloads raw lines, archives files, and then updates the file record" do
        expect(S3Api).to receive(:read).with("domino/logs/access.log-20251201.gz").and_return("binary-data")
        expect(Zlib).to receive(:gunzip).with("binary-data").and_return("GET index.html\n")

        expect(S3Api).to receive(:move).with("domino/logs/access.log-20251201.gz", "domino/archives/access.log-20251201.gz").and_return(nil)
        expect(S3Api).to receive(:move).with("domino/logs/error.log-20251201.gz", "domino/archives/error.log-20251201.gz").and_return(nil)

        apache_log_file.extractor.run

        expect(apache_log_file.raw_lines).to eq "GET index.html\n"
        expect(apache_log_file).to be_extracted
      end
    end

    context "with an ApacheLogFile record that has been extracted" do
      let(:state) { "extracted" }

      it "raises an error" do
        expect do
          apache_log_file.extractor.run
        end.to raise_error(ApacheLogFile::Extractor::NotPendingError)
      end
    end
  end
end
