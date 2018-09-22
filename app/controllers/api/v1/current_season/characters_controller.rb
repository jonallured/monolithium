module Api
  module V1
    module CurrentSeason
      class CharactersController < Api::V1::CurrentSeasonController
        expose(:current_characters) { CurrentCharacter.all(current_season) }
      end
    end
  end
end
