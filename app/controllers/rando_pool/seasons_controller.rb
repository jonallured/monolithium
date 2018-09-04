module RandoPool
  class SeasonsController < ApplicationController
    skip_before_action :ensure_admin
    expose(:seasons) { Season.all.order(:name) }
    expose(:season, find_by: :name, id: :season_name)
    expose(:weeks) { season.weeks }
    expose(:characters) { season.characters.sort_by(&:score).reverse }
  end
end
