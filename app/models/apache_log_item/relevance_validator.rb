class ApacheLogItem::RelevanceValidator < ActiveModel::Validator
  def validate(record)
    record.errors.add(:port, "irrelevant") if wrong_port?(record)
    record.errors.add(:request_method, "irrelevant") if not_get?(record)
    record.errors.add(:request_params, "irrelevant") if has_params?(record)
    record.errors.add(:request_path, "irrelevant") if not_html_file?(record)
    record.errors.add(:request_user_agent, "irrelevant") if bot_request?(record)
    record.errors.add(:response_status, "irrelevant") if not_ok?(record)
    record.errors.add(:website, "irrelevant") if wrong_website?(record)
  end

  private

  def wrong_port?(record)
    return false if record.port.nil?
    record.port != "443"
  end

  def not_get?(record)
    return false if record.request_method.nil?
    record.request_method != "GET"
  end

  def has_params?(record)
    record.request_params.present?
  end

  def not_html_file?(record)
    return false if record.request_path.nil?
    !record.request_path.match?(/\.html$/)
  end

  def bot_request?(record)
    return false if record.request_user_agent.nil?
    browser = Browser.new_with_limit(record.request_user_agent)
    browser.bot?
  end

  def not_ok?(record)
    return false if record.response_status.nil?
    record.response_status != "200"
  end

  def wrong_website?(record)
    return false if record.website.nil?
    record.website != "www.jonallured.com"
  end
end
