class TrainingDay::FillerDay
  def self.fill_after(date)
    return [] unless date == date.end_of_month

    filler_offsets = 1.upto(6 - date.wday).to_a
    filler_offsets.map { |offset| new(date + offset.days) }
  end

  def self.fill_before(date)
    return [] unless date == date.beginning_of_month

    filler_offsets = date.wday.downto(1).to_a
    filler_offsets.map { |offset| new(date - offset.days) }
  end

  attr_reader :date

  def initialize(date)
    @date = date
  end

  def intensity
    "filler"
  end

  def outcome
    :filler
  end
end
