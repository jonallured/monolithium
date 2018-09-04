module RandoPool
  class CharactersController < ApplicationController
    skip_before_action :ensure_admin
    expose(:season, find_by: :name, id: :season_name)
    expose(:character)
  end
end
