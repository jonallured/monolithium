class ApiController < ActionController::Base
  protect_from_forgery with: :null_session

  before_action :validate_client_token

  private

  def client_token_valid?
    Rails.application.secrets.client_token == request.headers['X-CLIENT-TOKEN']
  end

  def validate_client_token
    head :not_found unless client_token_valid?
  end
end
