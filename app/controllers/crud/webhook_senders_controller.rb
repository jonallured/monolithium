class Crud::WebhookSendersController < ApplicationController
  expose(:webhook_sender)
  expose(:webhook_senders) do
    WebhookSender.order(created_at: :desc).page(params[:page])
  end

  def show
    redirect_to crud_webhook_sender_path(WebhookSender.random) if random_id?
  end

  def create
    if webhook_sender.save
      flash.notice = "Webhook Sender created"
      redirect_to crud_webhook_sender_path(webhook_sender)
    else
      flash.alert = webhook_sender.errors.full_messages.to_sentence
      redirect_to new_crud_webhook_sender_path
    end
  end

  def update
    if webhook_sender.update(webhook_sender_params)
      flash.notice = "Webhook Sender updated"
      redirect_to crud_webhook_sender_path(webhook_sender)
    else
      flash.alert = webhook_sender.errors.full_messages.to_sentence
      redirect_to edit_crud_webhook_sender_path(webhook_sender)
    end
  end

  def destroy
    webhook_sender.destroy
    flash.notice = "Webhook Sender deleted"
    redirect_to crud_webhook_senders_path
  end

  private

  def webhook_sender_params
    params.require(:webhook_sender).permit(:name, :parser)
  end
end
