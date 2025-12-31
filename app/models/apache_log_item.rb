class ApacheLogItem < ApplicationRecord
  belongs_to :apache_log_file
  validates :line_number, :raw_line, presence: true
  validates_with RelevanceValidator

  def self.permitted_params
    [
      :apache_log_file_id,
      :browser_name,
      :line_number,
      :port,
      :raw_line,
      :referrer_host,
      :remote_ip_address,
      :remote_logname,
      :remote_user,
      :request_method,
      :request_params,
      :request_path,
      :request_protocol,
      :request_referrer,
      :request_user_agent,
      :requested_at,
      :response_size,
      :response_status,
      :website
    ]
  end

  def table_attrs
    [
      ["ApacheLogFile ID", apache_log_file_id],
      ["Browser Name", browser_name],
      ["Line Number", line_number],
      ["Port", port],
      ["Raw Line", raw_line],
      ["Referrer Host", referrer_host],
      ["Remote IP Address", remote_ip_address],
      ["Remote Logname", remote_logname],
      ["Remote User", remote_user],
      ["Request Method", request_method],
      ["Request Params", request_params],
      ["Request Path", request_path],
      ["Request Protocol", request_protocol],
      ["Request Referrer", request_referrer],
      ["Request User Agent", request_user_agent],
      ["Requested At", requested_at&.to_fs],
      ["Response Size", response_size],
      ["Response Status", response_status],
      ["Website", website],
      ["Created At", created_at.to_fs],
      ["Updated At", updated_at.to_fs]
    ]
  end
end
