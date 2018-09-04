module RandoPool
  class WeeksController < ApplicationController
    skip_before_action :ensure_admin
    expose(:season, find_by: :name, id: :season_name)
    expose(:week) { season.weeks.find_by number: params[:week_number] }
    expose(:games) { week.games.order :played_at }
    expose(:picks) { week.picks.sort_by(&:score).reverse }
    expose(:pick_presenter) { PickOfTheWeekPresenter.new games }
    expose(:next_week) { week.next_week }
    expose(:prev_week) { week.prev_week }
    expose(:rando_pick) { week.random_pick }
  end
end
