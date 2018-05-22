class ArtsyPullRequest
  def initialize(hook)
    @hook = hook
  end

  def as_json(_options)
    {
      title: title,
      url: url,
      username: username
    }
  end

  private

  def pull_request_data
    @hook.payload['pull_request']
  end

  def title
    pull_request_data['title']
  end

  def url
    pull_request_data['url']
  end

  def username
    pull_request_data['user']['login']
  end
end
