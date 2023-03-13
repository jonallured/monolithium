class ParseRawHookJob < ApplicationJob
  def perform(raw_hook_id)
    raw_hook = RawHook.find(raw_hook_id)
    return unless raw_hook

    WebhookSender.all.each { |sender| sender.handle(raw_hook) }
  end
end
