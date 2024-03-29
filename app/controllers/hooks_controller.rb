class HooksController < ApplicationController
  protect_from_forgery with: :null_session, only: :create
  skip_before_action :ensure_admin, only: :create
  before_action :verify_signature, only: :create

  expose(:hooks) { Hook.order(id: :desc).limit(20) }
  expose(:hook) do
    if params[:id]
      Hook.find(params[:id])
    else
      Hook.new(hook_params)
    end
  end

  def create
    if hook.save
      head :created
    else
      head :bad_request
    end
  end

  private

  def hook_params
    payload = JSON.parse payload_body
    {payload: payload}
  end

  def verify_signature
    head :not_found unless signatures_match?
  end

  def signatures_match?
    return false unless hub_signature

    signature = compute_signature
    Rack::Utils.secure_compare(signature, hub_signature)
  end

  def hub_signature
    request.headers["X-Hub-Signature"]
  end

  def compute_signature
    sha1 = OpenSSL::HMAC.hexdigest(
      OpenSSL::Digest.new("sha1"),
      Monolithium.config.hub_signature,
      payload_body
    )
    "sha1=#{sha1}"
  end

  def payload_body
    @payload_body ||= request.body.read
  end
end
