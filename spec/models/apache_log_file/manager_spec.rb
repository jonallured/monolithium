require "rails_helper"

describe ApacheLogFile::Manager do
  describe "#process_files" do
    before do
      expect(S3Api).to receive(:list).with("domino/logs/").and_return(keys)
    end

    context "with no files" do
      let(:keys) { [] }

      it "does nothing" do
        expect(ActiveJob).to_not receive(:perform_all_later)
        expect(S3Api).to_not receive(:delete)

        manager = ApacheLogFile::Manager.process_files

        expect(manager.existing_apache_log_files.count).to eq 0
        expect(manager.missing_dateexts.count).to eq 0
      end
    end

    context "with no matching files" do
      let(:keys) { ["invalid"] }

      it "does nothing" do
        expect(ActiveJob).to_not receive(:perform_all_later)
        expect(S3Api).to_not receive(:delete)

        manager = ApacheLogFile::Manager.process_files

        expect(manager.existing_apache_log_files.count).to eq 0
        expect(manager.missing_dateexts.count).to eq 0
      end
    end

    context "with a new access log file" do
      let(:keys) { ["domino/logs/access.log-20251201.gz"] }

      it "enqueues a job to import that dateext" do
        expect(ActiveJob).to receive(:perform_all_later)
        expect(S3Api).to_not receive(:delete)

        manager = ApacheLogFile::Manager.process_files

        expect(manager.existing_apache_log_files.count).to eq 0
        expect(manager.missing_dateexts.count).to eq 1
      end
    end

    context "with an existing access and error log file" do
      let(:keys) do
        [
          "domino/logs/access.log-20251201.gz",
          "domino/logs/error.log-20251201.gz"
        ]
      end

      it "deletes the access and error logs files" do
        FactoryBot.create(:apache_log_file, dateext: "20251201")

        expect(ActiveJob).to_not receive(:perform_all_later)
        expect(S3Api).to receive(:delete).with("domino/logs/access.log-20251201.gz")
        expect(S3Api).to receive(:delete).with("domino/logs/error.log-20251201.gz")

        manager = ApacheLogFile::Manager.process_files

        expect(manager.existing_apache_log_files.count).to eq 1
        expect(manager.missing_dateexts.count).to eq 0
      end
    end
  end
end
