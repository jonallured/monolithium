class PasswordController < ApplicationController
  skip_before_action :ensure_admin
  before_action :check_password, only: :create

  def create
    path = session.fetch(:redirect_to, root_path)
    session.clear
    session[:admin_password] = params[:admin_password]
    flash[:notice] = 'Password saved to session'
    redirect_to path
  end

  def clear
    session.clear
    flash[:notice] = 'Password removed from session'
    redirect_to root_path
  end

  private

  def password_matches?
    Rails.application.secrets[:admin_password] == params[:admin_password]
  end

  def check_password
    return if password_matches?

    flash[:error] = 'Password did not match'
    redirect_to sign_in_path
  end
end
