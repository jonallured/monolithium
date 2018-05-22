class ParseHookJob < ApplicationJob
  def perform(hook_id)
    hook = Hook.find_by id: hook_id
    return unless hook&.artsy_pull_request?
    artsy_pull_request = ArtsyPullRequest.new(hook)
    ActionCable.server.broadcast 'artsy_pull_requests', artsy_pull_request
  end
end
