class VanishingBoxController < ApplicationController
  def create
    payload = {
      body: params[:body],
      created_at: Time.now.to_fs
    }
    VanishingBoxChannel.broadcast(payload)
    head :created
  end
end
