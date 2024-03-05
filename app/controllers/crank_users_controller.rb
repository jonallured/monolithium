class CrankUsersController < ApplicationController
  skip_before_action :ensure_admin

  expose(:crank_user, build: -> { CrankUser.new_with_code }, find_by: :code, id: :code)

  def create
    if crank_user.save
      flash.notice = "Crank User created"
      redirect_to crank_user_path(crank_user)
    else
      flash.alert = crank_user.errors.full_messages.to_sentence
      redirect_to new_crank_user_path
    end
  end
end
