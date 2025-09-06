class VanishingBoxController < ApplicationController
  def create
    VanishingMessage.fire_and_forget(params[:secret])

    head :created
  end
end
