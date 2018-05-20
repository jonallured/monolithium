class HooksController < ApplicationController
  protect_from_forgery with: :null_session
  skip_before_action :ensure_admin
  before_action :verify_signature

  expose :hook

  def create
    if hook.save
      head :created
    else
      head :bad_request
    end
  end

  private

  def hook_params
    payload = JSON.parse request.body.read
    { payload: payload }
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
    request.headers['X-Hub-Signature']
  end

  def compute_signature
    request.body.rewind
    payload_body = request.body.read
    request.body.rewind
    sha1 = OpenSSL::HMAC.hexdigest(
      OpenSSL::Digest.new('sha1'),
      # this should come from secrets!!
      ENV['HUB_SIGNATURE'],
      payload_body
    )
    'sha1=' + sha1
  end
end
