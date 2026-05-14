class TrainingDay < ApplicationRecord
  INTENSITIES = %w[lift recovery rest]

  has_many :training_activities, dependent: :destroy
  accepts_nested_attributes_for :training_activities, allow_destroy: true, reject_if: :all_blank

  validates :date, presence: true
  validates :intensity, presence: true, inclusion: {in: INTENSITIES}
  validates :with_coach, inclusion: {in: [true, false]}

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
