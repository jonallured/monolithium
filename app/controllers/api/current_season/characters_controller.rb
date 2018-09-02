module Api
  module CurrentSeason
    class CharactersController < Api::CurrentSeasonController
      expose(:current_characters) { CurrentCharacter.all(current_season) }
    end
  end
end
