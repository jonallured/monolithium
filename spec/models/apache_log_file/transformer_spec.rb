require "rails_helper"

describe ApacheLogFile::Transformer do
  describe "#run" do
    let(:apache_log_file) do
      FactoryBot.create(
        :apache_log_file,
        dateext: "20251201",
        parsed_entries: nil,
        raw_lines: raw_lines,
        state: state
      )
    end

    context "with an ApacheLogFile that is not extracted" do
      let(:state) { "pending" }
      let(:raw_lines) { nil }

      it "raises an error" do
        expect do
          apache_log_file.transformer.run
        end.to raise_error(ApacheLogFile::Transformer::NotExtractedError)
      end
    end

    context "with an ApacheLogFile that has been extracted" do
      let(:state) { "extracted" }

      context "with a valid raw line" do
        let(:raw_lines) do
          [
            "www.jonallured.com:443",
            "1.1.1.1",
            "-",
            "-",
            "[14/Dec/2025:00:05:16 +0000]",
            '"GET / HTTP/1.1"',
            "200",
            "1",
            '"-"',
            '"-"'
          ].join(" ")
        end

        it "parses and normalizes that line then updates the file record" do
          apache_log_file.transformer.run

          first_entry = apache_log_file.parsed_entries.first
          expect(first_entry["browser_name"]).to eq "Unknown Browser"
          expect(first_entry["line_number"]).to eq 1
          expect(first_entry["port"]).to eq "443"
          expect(first_entry["raw_line"]).to eq raw_lines
          expect(first_entry["referrer_host"]).to eq "-"
          expect(first_entry["remote_ip_address"]).to eq "1.1.1.1"
          expect(first_entry["remote_logname"]).to eq "-"
          expect(first_entry["remote_user"]).to eq "-"
          expect(first_entry["request_method"]).to eq "GET"
          expect(first_entry["request_params"]).to eq nil
          expect(first_entry["request_path"]).to eq "/index.html"
          expect(first_entry["request_protocol"]).to eq "HTTP/1.1"
          expect(first_entry["request_referrer"]).to eq "-"
          expect(first_entry["request_user_agent"]).to eq "-"
          expected_time = Time.new(2025, 12, 14, 0, 5, 16, 0)
          expect(first_entry["requested_at"]).to eq expected_time.in_time_zone.as_json
          expect(first_entry["response_size"]).to eq "1"
          expect(first_entry["response_status"]).to eq "200"
          expect(first_entry["website"]).to eq "www.jonallured.com"

          expect(apache_log_file).to be_transformed
        end
      end

      context "with a malformed first line of request data" do
        let(:raw_lines) do
          first_line_of_request = '"MGLNDD_159.203.124.104_80\n"'

          [
            "www.jonallured.com:443",
            "1.1.1.1",
            "-",
            "-",
            "[14/Dec/2025:00:05:16 +0000]",
            first_line_of_request,
            "200",
            "1",
            '"-"',
            '"-"'
          ].join(" ")
        end

        it "puts the malformed line into path and sets the other parts to nil" do
          apache_log_file.transformer.run

          first_entry = apache_log_file.parsed_entries.first
          expect(first_entry["request_method"]).to eq nil
          expect(first_entry["request_params"]).to eq nil
          expect(first_entry["request_path"]).to eq "MGLNDD_159.203.124.104_80\\n"
          expect(first_entry["request_protocol"]).to eq nil
        end
      end

      context "with a request that has a referrer with path info" do
        let(:raw_lines) do
          request_referrer = '"https://jon.zone/post-1"'
          [
            "www.jonallured.com:443",
            "1.1.1.1",
            "-",
            "-",
            "[14/Dec/2025:00:05:16 +0000]",
            '"GET / HTTP/1.1"',
            "200",
            "1",
            request_referrer,
            '"-"'
          ].join(" ")
        end

        it "pulls out the referrer host into separate field" do
          apache_log_file.transformer.run

          first_entry = apache_log_file.parsed_entries.first
          expect(first_entry["referrer_host"]).to eq "jon.zone"
          expect(first_entry["request_referrer"]).to eq "https://jon.zone/post-1"
        end
      end

      context "with a request that has an invalid referrer" do
        let(:raw_lines) do
          request_referrer = '"invalid"'
          [
            "www.jonallured.com:443",
            "1.1.1.1",
            "-",
            "-",
            "[14/Dec/2025:00:05:16 +0000]",
            '"GET / HTTP/1.1"',
            "200",
            "1",
            request_referrer,
            '"-"'
          ].join(" ")
        end

        it "sets the referrer host to -" do
          apache_log_file.transformer.run

          first_entry = apache_log_file.parsed_entries.first
          expect(first_entry["referrer_host"]).to eq "-"
        end
      end

      context "with a request that has a malformed referrer" do
        let(:raw_lines) do
          request_referrer = '"\\\\x00"'
          [
            "www.jonallured.com:443",
            "1.1.1.1",
            "-",
            "-",
            "[14/Dec/2025:00:05:16 +0000]",
            '"GET / HTTP/1.1"',
            "200",
            "1",
            request_referrer,
            '"-"'
          ].join(" ")
        end

        it "sets the referrer host to -" do
          apache_log_file.transformer.run

          first_entry = apache_log_file.parsed_entries.first
          expect(first_entry["referrer_host"]).to eq "-"
        end
      end

      context "with a request path that includes the website" do
        let(:raw_lines) do
          first_line_of_request = '"GET https://www.jonallured.com/index.html HTTP/1.1"'

          [
            "www.jonallured.com:443",
            "1.1.1.1",
            "-",
            "-",
            "[14/Dec/2025:00:05:16 +0000]",
            first_line_of_request,
            "200",
            "1",
            '"-"',
            '"-"'
          ].join(" ")
        end

        it "removes website from the request path" do
          apache_log_file.transformer.run
          first_entry = apache_log_file.parsed_entries.first
          expect(first_entry["request_path"]).to eq "/index.html"
        end
      end

      context "with a request for root" do
        let(:raw_lines) do
          first_line_of_request = '"GET / HTTP/1.1"'

          [
            "www.jonallured.com:443",
            "1.1.1.1",
            "-",
            "-",
            "[14/Dec/2025:00:05:16 +0000]",
            first_line_of_request,
            "200",
            "1",
            '"-"',
            '"-"'
          ].join(" ")
        end

        it "coerces the path to '/index.html'" do
          apache_log_file.transformer.run
          first_entry = apache_log_file.parsed_entries.first
          expect(first_entry["request_path"]).to eq "/index.html"
        end
      end

      context "with a request for ?" do
        let(:raw_lines) do
          first_line_of_request = '"GET ? HTTP/1.1"'

          [
            "www.jonallured.com:443",
            "1.1.1.1",
            "-",
            "-",
            "[14/Dec/2025:00:05:16 +0000]",
            first_line_of_request,
            "200",
            "1",
            '"-"',
            '"-"'
          ].join(" ")
        end

        it "coerces the path to '/index.html'" do
          apache_log_file.transformer.run
          first_entry = apache_log_file.parsed_entries.first
          expect(first_entry["request_path"]).to eq "/index.html"
        end
      end
    end

    context "with an ApacheLogFile that has been transformed" do
      let(:state) { "transformed" }
      let(:raw_lines) { nil }

      it "raises an error" do
        expect do
          apache_log_file.transformer.run
        end.to raise_error(ApacheLogFile::Transformer::NotExtractedError)
      end
    end
  end
end
