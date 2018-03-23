class Project < ApplicationRecord
  validates :name, uniqueness: true

  def as_json(_options = {})
    json = super(only: %i[id name touched_at])
    json['touched_at'] = json['touched_at'].strftime('%m/%d/%y')
    json
  end
end
