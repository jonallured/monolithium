class Hook < ApplicationRecord
  validates :payload, presence: true

  def artsy_pull_request?
    owner_login == 'artsy' && action == 'opened' && pull_request?
  end

  private

  def owner_login
    payload.dig('repository', 'owner', 'login')
  end

  def action
    payload['action']
  end

  def pull_request?
    payload.keys.include?('pull_request')
  end
end
