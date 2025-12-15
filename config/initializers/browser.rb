module Browser
  def self.new_with_limit(user_agent)
    limit = user_agent_size_limit - 1
    limited_user_agent = user_agent.first(limit)
    new(limited_user_agent)
  end
end
