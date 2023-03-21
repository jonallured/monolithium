class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :ensure_admin

  def admin?
    @admin ||= session_password_matches?
  end
  helper_method :admin?

  private

  def session_password_matches?
    Monolithium.config.admin_password == session[:admin_password]
  end

  def ensure_admin
    return if session_password_matches?

    session.clear
    session[:redirect_to] = request.path
    redirect_to sign_in_path
  end
end
