class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :ensure_admin

  private

  def session_password_matches?
    Rails.application.secrets[:admin_password] == session[:admin_password]
  end

  def ensure_admin
    return if session_password_matches?
    session.clear
    redirect_to sign_in_path
  end
end
