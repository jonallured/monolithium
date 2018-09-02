require 'rails_helper'

describe 'POST /api/v1/current_season/picks' do
  it 'creates a pick and returns all picks for that character' do
    season = Season.create
    player = Player.create
    character = Character.create season: season, player: player
    team = Team.create
    week = Week.create season: season, number: 1

    pick_params = {
      character_id: character.id,
      team_id: team.id,
      week_number: week.number
    }

    headers = { 'X-CLIENT-TOKEN' => 'shhh' }
    post(
      '/api/v1/current_season/picks',
      params: pick_params,
      headers: headers,
      as: :json
    )

    expect(character.picks.count).to eq 1

    expect(response.code).to eq '201'
    expect(response_json).to eq(
      [{ 'week_number' => week.number, 'team_id' => team.id }]
    )
  end
end
