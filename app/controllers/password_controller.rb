class PasswordController < ApplicationController
  skip_before_action :ensure_admin

  def create
    if password_matches?
      session.clear
      session[:admin_password] = params[:admin_password]
      flash[:notice] = 'Password saved to session'
      redirect_to root_path
    else
      flash[:error] = 'Password did not match'
      redirect_to sign_in_path
    end
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
end
