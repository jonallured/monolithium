class Project < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  def table_attrs
    [
      ["Name", name],
      ["Touched At", touched_at&.to_formatted_s(:long)],
      ["Created At", created_at.to_formatted_s(:long)],
      ["Updated At", updated_at.to_formatted_s(:long)]
    ]
  end

  def as_json(_options = {})
    json = super(only: %i[id name touched_at])
    formatted_touched_at = Date.parse(json["touched_at"]).strftime("%m/%d/%y")
    json["touched_at"] = formatted_touched_at
    json
  end
end
