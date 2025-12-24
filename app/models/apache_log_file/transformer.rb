class ApacheLogFile::Transformer < ActiveRecord::AssociatedObject
  class NotExtractedError < StandardError; end

  RAW_LINE_PATTERN = /^(\S+):(\d+) (\S+) (\S+) (\S+) \[([^\]]+)\] "((?:[^"]|\\")*)" (\d+) (\d+) "((?:[^"]|\\")*)" "((?:[^"]|\\")*)"/

  def run
    raise NotExtractedError unless apache_log_file.extracted?

    parse_raw_lines
    normalize_parsed_entries

    apache_log_file.update(
      parsed_entries: @parsed_entries,
      state: "transformed"
    )
  end

  private

  def parse_raw_lines
    lines = apache_log_file.raw_lines.split("\n").compact

    @parsed_entries = lines.each_with_index.map do |line, index|
      line_number = index + 1
      parse_raw_line(line, line_number)
    end
  end

  def parse_raw_line(line, line_number)
    match_data = line.match(RAW_LINE_PATTERN)
    browser = Browser.new_with_limit(match_data[11])
    requested_at = Time.strptime(match_data[6], "%d/%b/%Y:%H:%M:%S %z").in_time_zone
    request_line_parts = match_data[7].split(" ")

    if request_line_parts.count == 3
      request_method, request_path_and_params, request_protocol = request_line_parts
      request_path, request_params = request_path_and_params.split("?")
      request_path = "/" if request_path.nil?
    else
      request_method = nil
      request_params = nil
      request_path = match_data[7]
      request_protocol = nil
    end

    {
      browser_name: browser.name,
      line_number: line_number,
      port: match_data[2],
      raw_line: line,
      remote_ip_address: match_data[3],
      remote_logname: match_data[4],
      remote_user: match_data[5],
      request_method: request_method,
      request_params: request_params,
      request_path: request_path,
      request_protocol: request_protocol,
      request_referrer: match_data[10],
      request_user_agent: match_data[11],
      requested_at: requested_at,
      response_size: match_data[9],
      response_status: match_data[8],
      website: match_data[1]
    }
  end

  def normalize_parsed_entries
    @parsed_entries.each do |entry|
      normalize_entry(entry)
    end
  end

  def normalize_entry(entry)
    if entry[:request_path].starts_with?("http") && entry[:request_path].include?(entry[:website])
      entry[:request_path] = entry[:request_path].split(entry[:website]).last
    end

    if entry[:request_path] == "/"
      entry[:request_path] = "/index.html"
    end

    begin
      entry[:referrer_host] = URI.parse(entry[:request_referrer]).host || "-"
    rescue URI::InvalidURIError
      entry[:referrer_host] = "-"
    end
  end
end
