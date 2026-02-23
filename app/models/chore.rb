class Chore < ApplicationRecord
  DAY_NAMES = Date::DAYNAMES.map(&:downcase)

  enum :assignee, {jon: 0, jess: 1, jack: 2}, validate: true

  validates :due_days, presence: true
  validates :title, presence: true

  def self.day_names_to_numbers(names)
    return [] if names.nil?
    return (0..6).to_a if names.include?("all")

    names.map { |name| DAY_NAMES.index(name) }
  end

  def self.permitted_params
    [
      :assignee,
      :title
    ]
  end

  def daily?
    due_days.count == 7
  end

  def due_on?(name)
    name_index = DAY_NAMES.index(name)
    due_days.include?(name_index)
  end

  def table_attrs
    [
      ["Title", title],
      ["Assignee", assignee],
      ["Due Days", due_days.join(" ")],
      ["Created At", created_at],
      ["Updated At", updated_at]
    ]
  end
end
