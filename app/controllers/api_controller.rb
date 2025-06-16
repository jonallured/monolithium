class ApiController < ActionController::Base
  CLIENT_TOKEN_HEADER = "HTTP_X_MLI_CLIENT_TOKEN"
  CLIENT_TOKEN_PARAM = :mli_client_token

  protect_from_forgery with: :null_session

  before_action :validate_client_token

  private

  def client_token_valid?
    client_token_header = request.headers.to_h[CLIENT_TOKEN_HEADER]
    client_token_param = params[CLIENT_TOKEN_PARAM]
    client_token = client_token_header || client_token_param
    Monolithium.config.client_token == client_token
  end

  def validate_client_token
    head :not_found unless client_token_valid?
  end
end
