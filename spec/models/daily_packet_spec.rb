require "rails_helper"

describe DailyPacket do
  describe ".produce_for" do
    it "renders and writes the pdf data to s3" do
      mock_view = double(:mock_view, pdf_data: "PDF GOES HERE")
      expect(DailyPacketView).to receive(:new).and_return(mock_view)

      expect(S3Api).to receive(:write).with(
        "daily-packets/2001-02-03.pdf",
        "PDF GOES HERE"
      )

      date = Date.parse("2001-02-03")
      DailyPacket.produce_for(date)
    end
  end
end
