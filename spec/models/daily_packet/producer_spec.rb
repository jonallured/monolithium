require "rails_helper"

describe DailyPacket::Producer do
  describe ".save_to" do
    before do
      allow(FeedbinStats).to receive(:compute).and_return([0, 0])
    end

    context "with an invalid target" do
      it "raises an ArgumentError" do
        expect do
          DailyPacket::Producer.save_to(:invalid)
        end.to raise_error(ArgumentError)
      end
    end
    context "when the target is disk" do
      it "renders and writes the pdf data locally" do
        mock_view = double(:mock_view)
        expect(DailyPacket::PdfView).to receive(:new).and_return(mock_view)
        expect(mock_view).to receive(:save_as).with("tmp/daily_packet.pdf").and_return(nil)
        DailyPacket::Producer.save_to(:disk)
      end
    end

    context "when the target is disk" do
      it "renders and writes the pdf data to s3" do
        mock_view = double(:mock_view, pdf_data: "PDF GOES HERE")
        expect(DailyPacket::PdfView).to receive(:new).and_return(mock_view)

        expect(S3Api).to receive(:write).with(
          "daily-packets/2001-02-03.pdf",
          "PDF GOES HERE"
        )

        date = Date.parse("2001-02-03")
        DailyPacket::Producer.save_to(:s3, date)
      end
    end
  end
end
