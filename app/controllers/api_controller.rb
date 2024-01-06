class ApiController < ActionController::Base
  CLIENT_TOKEN_HEADER = "X-MLI-CLIENT-TOKEN"

  protect_from_forgery with: :null_session

  before_action :validate_client_token

  private

  def client_token_valid?
    client_token = request.headers[CLIENT_TOKEN_HEADER]
    Monolithium.config.client_token == client_token
  end

  def validate_client_token
    head :not_found unless client_token_valid?
  end
end
