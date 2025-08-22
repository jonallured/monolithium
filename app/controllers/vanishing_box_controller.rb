class VanishingBoxController < ApplicationController
  def create
    VanishingMessage.fire_and_forget(params[:body])

    head :created
  end
end
