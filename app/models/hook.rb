class Hook < ApplicationRecord
  validates :payload, presence: true

  after_create_commit :created

  def pr_title
    payload.dig("pull_request", "title")
  end

  def artsy_pull_request?
    owner_login == "artsy" && action == "opened" && pull_request?
  end

  private

  def created
    broadcast_prepend_later_to "hooks"
  end

  def owner_login
    payload.dig("repository", "owner", "login")
  end

  def action
    payload["action"]
  end

  def pull_request?
    payload.key?("pull_request")
  end
end
