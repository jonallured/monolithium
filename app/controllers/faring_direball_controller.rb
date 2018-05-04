class FaringDireballController < ApplicationController
  skip_before_action :ensure_admin

  def index
    render json: FaringDireball.feed_data
  end
end
