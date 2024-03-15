class Crud::WarmFuzziesController < ApplicationController
  expose(:warm_fuzzy)
  expose(:warm_fuzzies) do
    WarmFuzzy.order(created_at: :desc).page(params[:page])
  end

  def show
    redirect_to crud_warm_fuzzy_path(WarmFuzzy.random) if params[:id] == "random"
  end

  def create
    if warm_fuzzy.save
      flash.notice = "Warm Fuzzy created"
      redirect_to crud_warm_fuzzy_path(warm_fuzzy)
    else
      flash.alert = warm_fuzzy.errors.full_messages.to_sentence
      redirect_to new_crud_warm_fuzzy_path
    end
  end

  def update
    if warm_fuzzy.update(warm_fuzzy_params)
      flash.notice = "Warm Fuzzy updated"
      redirect_to crud_warm_fuzzy_path(warm_fuzzy)
    else
      flash.alert = warm_fuzzy.errors.full_messages.to_sentence
      redirect_to edit_crud_warm_fuzzy_path(warm_fuzzy)
    end
  end

  def destroy
    warm_fuzzy.destroy
    flash.notice = "Warm Fuzzy deleted"
    redirect_to crud_warm_fuzzies_path
  end

  private

  def warm_fuzzy_params
    params.require(:warm_fuzzy).permit(:author, :body, :received_at, :screenshot, :title)
  end
end
