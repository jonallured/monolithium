class ReadingListController < ApplicationController
  skip_before_action :ensure_admin
  expose(:reading_list) { ReadingList.new(params[:year].to_i) }
end
