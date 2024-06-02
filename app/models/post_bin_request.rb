class PostBinRequest < ApplicationRecord
  CHANNEL_NAME = "post_bin_requests"

  after_create_commit :created

  private

  def created
    broadcast_prepend_later_to CHANNEL_NAME, template: "post_bin/_post_bin_request"
  end
end
