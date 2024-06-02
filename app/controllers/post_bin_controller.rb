class PostBinController < ApplicationController
  expose(:post_bin_requests) { PostBinRequest.all.order(created_at: :desc).limit(10) }
end
