class Crud::PostBinRequestsController < ApplicationController
  expose(:post_bin_request)
  expose(:post_bin_requests) do
    PostBinRequest.order(created_at: :desc).page(params[:page])
  end

  def show
    redirect_to crud_post_bin_request_path(PostBinRequest.random) if random_id?
  end

  def create
    if post_bin_request.save
      flash.notice = "Post Bin Request created"
      redirect_to crud_post_bin_request_path(post_bin_request)
    else
      flash.alert = post_bin_request.errors.full_messages.to_sentence
      redirect_to new_crud_post_bin_request_path
    end
  end

  def update
    if post_bin_request.update(post_bin_request_params)
      flash.notice = "Post Bin Request updated"
      redirect_to crud_post_bin_request_path(post_bin_request)
    else
      flash.alert = post_bin_request.errors.full_messages.to_sentence
      redirect_to edit_crud_post_bin_request_path(post_bin_request)
    end
  end

  def destroy
    post_bin_request.destroy
    flash.notice = "Post Bin Request deleted"
    redirect_to crud_post_bin_requests_path
  end

  private

  def post_bin_request_params
    params.require(:post_bin_request).permit(PostBinRequest.permitted_params)
  end
end
