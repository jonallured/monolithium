module Help
  def self.valid_work_day?(hash)
    !empty_work_day?(hash) && !existing_work_day?(hash)
  end

  def self.empty_work_day?(hash)
    keys = %w[adjust_minutes in_minutes out_minutes pto_minutes]
    hash.values_at(*keys).uniq == [0]
  end

  def self.existing_work_day?(hash)
    WorkDay.exists?(date: hash['date'])
  end
end

task migrate_work_days: :environment do
  url = 'https://forty-rails.herokuapp.com'
  conn = Faraday.new(url: url) do |faraday|
    faraday.headers['X-USER-TOKEN'] = Rails.application.secrets.user_token
    faraday.adapter Faraday.default_adapter
  end

  years = (2016..2018)
  numbers = (1..52)

  weeks = years.flat_map { |year| numbers.map { |number| [year, number] } }

  work_day_attrses = weeks.flat_map do |year, number|
    path = "/api/v1/work_weeks/#{year}/#{number}"
    response = conn.get path
    json = JSON.parse response.body
    print '.'
    work_days = json['work_days']
    work_days.select(&Help.method(:valid_work_day?))
  end

  puts "\ncreating #{work_day_attrses.count} new WorkDay records"

  work_day_attrses.each(&WorkDay.method(:create!))
end
