class ApiController < ActionController::Base
  CLIENT_TOKEN_HEADER = "HTTP_X_MLI_CLIENT_TOKEN"
  CLIENT_TOKEN_PARAM = :mli_client_token

  protect_from_forgery with: :null_session

  rescue_from ActionController::ParameterMissing, with: :parameter_missing
  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  before_action :validate_client_token

  exposure_config(:random_or_find, find: lambda do |id, scope|
    random_id? ? scope.random : scope.find(id)
  end)

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

  def parameter_missing(error)
    render json: {error: error}, status: :bad_request
  end

  def record_invalid(error)
    render json: {error: error}, status: :bad_request
  end

  def record_not_found(error)
    render json: {error: error}, status: :not_found
  end

  def random_id?
    params[:id] == "random"
  end
end
