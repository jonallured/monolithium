namespace :training do
  desc "Populate workouts"
  task workouts: :environment do
    url = "https://jonallured-public.s3.amazonaws.com/workouts.csv"
    response = Faraday.get(url)
    rows = CSV.parse(response.body, headers: true)
    rows.each do |row|
      Workout.create(row.to_h)
    end
  end

  desc "Backfill training days"
  task training_days: :environment do
    url = "https://jonallured-public.s3.amazonaws.com/training_days.csv"
    response = Faraday.get(url)
    rows = CSV.parse(response.body, headers: true)
    rows.each do |row|
      month, day = row["date"].split("/").map(&:to_i)
      date = Date.new(2026, month, day)
      attrs = {
        completed_at: date,
        date: date,
        intensity: row["intensity"],
        with_coach: row["with_coach"] == "true"
      }
      TrainingDay.create(attrs)
    end
  end

  desc "Backfill training activities"
  task training_activities: :environment do
    url = "https://jonallured-public.s3.amazonaws.com/training_activities.csv"
    response = Faraday.get(url)
    rows = CSV.parse(response.body, headers: true)
    rows.each do |row|
      month, day = row["training_date"].split("/").map(&:to_i)
      date = Date.new(2026, month, day)
      training_day = TrainingDay.find_by(date: date)
      attrs = {
        training_day: training_day,
        workout_id: row["workout_id"]
      }
      TrainingActivity.create(attrs)
    end
  end
end
