class ParseHookJob < ApplicationJob
  def perform(hook_id)
    ActionCable.server.broadcast 'artsy_pull_requests', hook_id: hook_id
  end
end
