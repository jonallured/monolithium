require 'rails_helper'

describe 'GET /api/v1/current_season/characters' do
  it 'returns the current characters' do
    team = Team.create
    season = Season.create
    week = season.weeks.create number: 1
    player = Player.create name: 'Player One'
    character = Character.create season: season, player: player, out: false
    character.picks.create week: week, team: team

    headers = { 'X-CLIENT-TOKEN' => 'shhh' }
    get '/api/v1/current_season/characters', headers: headers, as: :json

    expect(response.code).to eq '200'
    expect(response_json).to eq(
      [
        {
          'id' => character.id,
          'player_name' => player.name,
          'out' => character.out,
          'picks' => [
            { 'week_number' => week.number, 'team_id' => team.id }
          ]
        }
      ]
    )
  end
end
