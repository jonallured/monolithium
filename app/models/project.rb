class Project < ApplicationRecord
  validates :name, uniqueness: true

  def as_json(_options = {})
    json = super(only: %i[id name touched_at])
    formatted_touched_at = Date.parse(json["touched_at"]).strftime("%m/%d/%y")
    json["touched_at"] = formatted_touched_at
    json
  end
end
