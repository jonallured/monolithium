require 'open-uri'
require 'csv'

task migrate_rando: :environment do
  [
    Player,
    Season,
    Team,
    Week,       # belongs_to Season
    Game,       # belongs_to Team, Week
    RandomPick, # belongs_to Team, Week
    Character,  # belongs_to Player, Season
    Pick        # belongs_to Character, Week, Team
  ].each do |klass|
    data = open("http://jonallured.com/rando/#{klass.to_s.downcase}.csv").read
    rows = CSV.parse(data, headers: true)

    rows.each do |row|
      attrs = row.to_hash
      klass.create! attrs
    rescue ActiveRecord::ActiveRecordError => e
      puts attrs
      puts e
    end

    puts "imported #{klass}"
  end

  ActiveRecord::Base.connection.tables.each do |t|
    ActiveRecord::Base.connection.reset_pk_sequence!(t)
  end
end
