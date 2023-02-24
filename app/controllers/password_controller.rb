class PasswordController < ApplicationController
  skip_before_action :ensure_admin
  before_action :verify_password, only: :create

  def create
    path = session.fetch(:redirect_to, root_path)
    session.clear
    session[:admin_password] = params[:admin_password]
    flash[:notice] = t("password.saved")
    redirect_to path
  end

  def clear
    session.clear
    flash[:notice] = t("password.clear")
    redirect_to root_path
  end

  private

  def verify_password
    return if password_matches?

    flash[:alert] = t("password.mismatch")
    redirect_to sign_in_path
  end

  def password_matches?
    Rails.application.secrets[:admin_password] == params[:admin_password]
  end
end
