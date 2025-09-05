class ProduceDailyPacketJob < ApplicationJob
  def perform
    DailyPacket::Producer.save_to(:s3)
  end
end
