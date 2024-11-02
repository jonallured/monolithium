require "rails_helper"

describe DailyPacket do
  describe ".save_locally" do
    it "renders and writes the pdf data locally" do
      mock_view = double(:mock_view)
      expect(DailyPacketView).to receive(:new).and_return(mock_view)

      expect(mock_view).to receive(:save_as).with("tmp/daily_packet.pdf").and_return(nil)

      date = Date.parse("2001-02-03")
      DailyPacket.save_locally(date)
    end
  end

  describe ".save_to_s3" do
    it "renders and writes the pdf data to s3" do
      mock_view = double(:mock_view, pdf_data: "PDF GOES HERE")
      expect(DailyPacketView).to receive(:new).and_return(mock_view)

      expect(S3Api).to receive(:write).with(
        "daily-packets/2001-02-03.pdf",
        "PDF GOES HERE"
      )

      date = Date.parse("2001-02-03")
      DailyPacket.save_to_s3(date)
    end
  end
end
