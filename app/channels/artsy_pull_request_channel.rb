class ArtsyPullRequestChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'artsy_pull_requests'
  end
end
