class Hook < ApplicationRecord
  validates :payload, presence: true

  def artsy_pull_request?
    login = payload.dig('repository', 'owner', 'login')
    login == 'artsy'
  end
end
