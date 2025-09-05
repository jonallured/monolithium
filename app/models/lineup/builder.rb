class Lineup::Builder
  def self.ensure_current
    Lineup.create_next while Lineup.current.nil?
    Lineup.create_next
  end
end
