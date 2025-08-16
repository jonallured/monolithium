class Crud::ThingsController < ApplicationController
  expose(:thing)
  expose(:things) do
    Thing.order(created_at: :desc).page(params[:page])
  end

  def show
    redirect_to crud_thing_path(Thing.random) if random_id?
  end

  def create
    if thing.save
      flash.notice = "Thing created"
      redirect_to crud_thing_path(thing)
    else
      flash.alert = thing.errors.full_messages.to_sentence
      redirect_to new_crud_thing_path
    end
  end

  def update
    if thing.update(thing_params)
      flash.notice = "Thing updated"
      redirect_to crud_thing_path(thing)
    else
      flash.alert = thing.errors.full_messages.to_sentence
      redirect_to edit_crud_thing_path(thing)
    end
  end

  def destroy
    thing.destroy
    flash.notice = "Thing deleted"
    redirect_to crud_things_path
  end

  private

  def thing_params
    params.require(:thing).permit(Thing.permitted_params)
  end
end
