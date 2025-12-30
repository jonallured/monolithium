class Crud::ApacheLogItemsController < ApplicationController
  expose(:apache_log_item)
  expose(:apache_log_items) do
    ApacheLogItem.order(created_at: :desc).page(params[:page])
  end

  def show
    redirect_to crud_apache_log_item_path(ApacheLogItem.random) if random_id?
  end

  def create
    if apache_log_item.save
      flash.notice = "Apache Log Item created"
      redirect_to crud_apache_log_item_path(apache_log_item)
    else
      flash.alert = apache_log_item.errors.full_messages.to_sentence
      redirect_to new_crud_apache_log_item_path
    end
  end

  def update
    if apache_log_item.update(apache_log_item_params)
      flash.notice = "Apache Log Item updated"
      redirect_to crud_apache_log_item_path(apache_log_item)
    else
      flash.alert = apache_log_item.errors.full_messages.to_sentence
      redirect_to edit_crud_apache_log_item_path(apache_log_item)
    end
  end

  def destroy
    apache_log_item.destroy
    flash.notice = "Apache Log Item deleted"
    redirect_to crud_apache_log_items_path
  end

  private

  def apache_log_item_params
    params.require(:apache_log_item).permit(ApacheLogItem.permitted_params)
  end
end
