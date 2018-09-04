class StaticController < ApplicationController
  skip_before_action :ensure_admin

  expose(:wins) { Rando.wins }
  expose(:losses) { Rando.losses }
  expose(:ratio) { Rando.ratio }

  expose(:stats) { compute_stats }
  expose(:running_record) { Rando.running_record }

  private

  def compute_stats
    Season.order(:name).map do |season|
      pick_counts = season.weeks.order(:number).map { |week| week.picks.count }
      { name: season.name, pick_counts: pick_counts }
    end
  end
end
