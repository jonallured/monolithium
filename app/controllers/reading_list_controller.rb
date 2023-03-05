class ReadingListController < ApplicationController
  expose(:reading_list) { ReadingList.new(params[:year].to_i) }
end
