class Crud::RawHooksController < ApplicationController
  expose(:raw_hook)
  expose(:raw_hooks) do
    RawHook.order(created_at: :desc).page(params[:page])
  end

  def show
    redirect_to crud_raw_hook_path(RawHook.random) if random_id?
  end

  def create
    if raw_hook.save
      flash.notice = "Raw Hook created"
      redirect_to crud_raw_hook_path(raw_hook)
    else
      flash.alert = raw_hook.errors.full_messages.to_sentence
      redirect_to new_crud_raw_hook_path
    end
  end

  def update
    if raw_hook.update(raw_hook_params)
      flash.notice = "Raw Hook updated"
      redirect_to crud_raw_hook_path(raw_hook)
    else
      flash.alert = raw_hook.errors.full_messages.to_sentence
      redirect_to edit_crud_raw_hook_path(raw_hook)
    end
  end

  def destroy
    raw_hook.destroy
    flash.notice = "Raw Hook deleted"
    redirect_to crud_raw_hooks_path
  end

  private

  def raw_hook_params
    permitted_params = params.require(:raw_hook).permit(RawHook.permitted_params)

    {
      body: permitted_params[:body],
      headers: MaybeJson.parse(permitted_params[:headers]),
      params: MaybeJson.parse(permitted_params[:params])
    }
  end
end
