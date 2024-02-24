class Crud::PostBinRequestsController < ApplicationController
  expose(:post_bin_request)
  expose(:post_bin_requests) { PostBinRequest.all.order(created_at: :desc).limit(10) }
end
