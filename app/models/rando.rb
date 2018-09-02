class Rando
  def self.wins
    RandomPick.all.select(&:correct?).count
  end

  def self.losses
    RandomPick.count - self.wins
  end

  def self.ratio
    ratio = self.wins / RandomPick.count.to_f
    sprintf( "%0.03f", ratio)
  end

  def self.running_record
    pick_scores = RandomPick.order(created_at: :asc).map(&:to_i)

    record = []

    pick_scores.inject(0) do |memo, score|
      total = memo + score
      record << total
      total
    end

    record
  end
end
