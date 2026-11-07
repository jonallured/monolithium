class PasswordController < ApplicationController
  skip_before_action :ensure_admin
  rate_limit to: 10, within: 3.minutes, only: :create, with: :too_many_attempts
  before_action :verify_password, only: :create

  def create
    path = session.fetch(:redirect_to, dashboard_path)
    session.clear
    admin_password_digest = SecretCheck.digest(params[:admin_password])
    session[:admin_password_digest] = admin_password_digest
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
    SecretCheck.match?(Monolithium.config.admin_password, params[:admin_password])
  end

  def too_many_attempts
    flash[:alert] = t("password.too_many_attempts")
    redirect_to sign_in_path
  end
end
