require 'rails_helper'

describe 'GET /api/v1/current_season/rando_picks' do
  it 'returns the rando picks for the current season' do
    season = Season.create
    week = Week.create season: season, number: 1
    team = Team.create
    RandomPick.create week: week, team: team

    headers = { 'X-CLIENT-TOKEN' => 'shhh' }
    get '/api/v1/current_season/rando_picks', headers: headers, as: :json

    expect(response.code).to eq '200'
    expect(response_json).to eq(
      [
        { 'week_number' => week.number, 'team_id' => team.id }
      ]
    )
  end
end

describe 'POST /api/v1/current_season/rando_picks' do
  it 'creates a random pick and returns them all for the current season' do
    season = Season.create
    team = Team.create
    week = Week.create season: season, number: 1

    pick_params = {
      team_id: team.id,
      week_number: week.number
    }

    headers = { 'X-CLIENT-TOKEN' => 'shhh' }
    post(
      '/api/v1/current_season/rando_picks',
      params: pick_params,
      headers: headers,
      as: :json
    )

    random_picks = RandomPick.all
    expect(random_picks.count).to eq 1

    expect(response.code).to eq '201'

    random_pick = random_picks.first
    expect(response_json).to eq(
      [{
        'week_number' => random_pick.week.number,
        'team_id' => random_pick.team.id
      }]
    )
  end
end
