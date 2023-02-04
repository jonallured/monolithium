class StaticController < ApplicationController
  ALERT_MESSAGE = 'This is a sample alert!'.freeze
  NOTICE_MESSAGE = 'This is a sample notice.'.freeze

  skip_before_action :ensure_admin

  layout 'root', only: :root

  def flashes
    {
      alert: params[:alert] || ALERT_MESSAGE,
      notice: params[:notice] || NOTICE_MESSAGE
    }.each do |type, message|
      flash.now[type] = message.presence
    end
  end
end
