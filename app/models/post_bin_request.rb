class PostBinRequest < ApplicationRecord
  CHANNEL_NAME = "post_bin_requests"

  after_create_commit :created

  def self.permitted_params
    [
      :body,
      :headers,
      :params
    ]
  end

  def table_attrs
    [
      ["Created At", created_at.to_fs],
      ["Updated At", updated_at.to_fs]
    ]
  end

  private

  def created
    broadcast_prepend_later_to CHANNEL_NAME, template: "post_bin/_post_bin_request"
  end
end
