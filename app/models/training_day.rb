class TrainingDay < ApplicationRecord
  INTENSITIES = %w[lift recovery rest]

  has_many :training_activities, dependent: :destroy
  accepts_nested_attributes_for :training_activities, allow_destroy: true, reject_if: :all_blank

  validates :date, presence: true
  validates :intensity, presence: true, inclusion: {in: INTENSITIES}
  validates :with_coach, inclusion: {in: [true, false]}

  def self.current_streak
    dates = where.not(intensity: "rest").order(date: :desc).pluck(:date)
    return 0 if dates.empty?

    most_recent_is_too_old = dates.first < Date.yesterday
    return 0 if most_recent_is_too_old

    streak = 1

    dates.each_cons(2) do |a, b|
      break unless a - b == 1
      streak += 1
    end

    streak
  end

  def self.longest_streak
    dates = where.not(intensity: "rest").order(date: :desc).pluck(:date)
    return 0 if dates.empty?

    max_streak = streak = 1

    dates.each_cons(2) do |a, b|
      if a - b == 1
        streak += 1
        max_streak = [max_streak, streak].max
      else
        streak = 1
      end
    end

    max_streak
  end

  def self.populate(year, month)
    all_month = Date.new(year, month, 1).all_month
    all_month.each do |date|
      next if TrainingDay.where(date: date).any?

      lift_day = date.monday? || date.wednesday? || date.friday?
      intensity = lift_day ? "lift" : "recovery"
      attrs = {
        date: date,
        intensity: intensity,
        with_coach: date.monday?
      }

      TrainingDay.create(attrs)
    end
  end

  def self.permitted_params
    [
      :date,
      :completed_at,
      :intensity,
      :with_coach
    ]
  end

  def table_attrs
    [
      ["Date", date],
      ["Intensity", intensity],
      ["With Coach", with_coach],
      ["Completed At", completed_at],
      ["Created At", created_at],
      ["Updated At", updated_at]
    ]
  end

  def outcome
    if intensity == "rest"
      :missed
    elsif completed_at.nil?
      :going
    else
      :went
    end
  end

  def summary
    suffix = with_coach ? "with coach" : nil
    [intensity, suffix].compact.join(" ")
  end
end
