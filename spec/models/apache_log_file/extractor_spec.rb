require "rails_helper"

describe ApacheLogFile::Extractor do
  describe ".find_missing" do
    context "with no keys" do
      let(:keys) { [] }

      it "returns an empty array" do
        expect(S3Api).to receive(:list).with("domino/logs/").and_return(keys)
        missing_keys = ApacheLogFile::Extractor.find_missing
        expect(missing_keys).to eq []
      end
    end

    context "with no matching keys" do
      let(:keys) { ["domino/logs/access.log"] }

      it "returns an empty array" do
        expect(S3Api).to receive(:list).with("domino/logs/").and_return(keys)
        missing_keys = ApacheLogFile::Extractor.find_missing
        expect(missing_keys).to eq []
      end
    end

    context "with a matching key that is missing" do
      let(:keys) { ["domino/logs/access.log-20251201.gz"] }

      it "returns the dateext from that missing key" do
        expect(S3Api).to receive(:list).with("domino/logs/").and_return(keys)
        missing_keys = ApacheLogFile::Extractor.find_missing
        expect(missing_keys).to eq ["20251201"]
      end
    end

    context "with a few matching keys that are missing" do
      let(:keys) do
        %w[
          domino/logs/access.log-20251203.gz
          domino/logs/access.log-20251201.gz
          domino/logs/access.log-20251202.gz
        ]
      end

      it "returns the dateexts in sorted order" do
        expect(S3Api).to receive(:list).with("domino/logs/").and_return(keys)
        missing_keys = ApacheLogFile::Extractor.find_missing
        expect(missing_keys).to eq(
          %w[
            20251201
            20251202
            20251203
          ]
        )
      end
    end

    context "with overlap" do
      let(:apache_log_file) { FactoryBot.create(:apache_log_file, dateext: "20251201") }
      let(:keys) { ["domino/logs/access.log-#{apache_log_file.dateext}.gz"] }

      it "raises an error" do
        expect(S3Api).to receive(:list).with("domino/logs/").and_return(keys)
        expect do
          ApacheLogFile::Extractor.find_missing
        end.to raise_error(ApacheLogFile::Extractor::UnexpectedOverlapError)
      end
    end
  end

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
