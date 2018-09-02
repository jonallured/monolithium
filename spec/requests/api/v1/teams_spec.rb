require 'rails_helper'

describe 'GET /api/v1/teams' do
  it 'returns the teams' do
    bears = Team.create name: 'Bears'
    seahawks = Team.create name: 'Seahawks'

    headers = { 'X-CLIENT-TOKEN' => 'shhh' }
    get '/api/v1/teams', headers: headers, as: :json

    expect(response.code).to eq '200'
    expect(response_json).to eq(
      [
        {
          'id' => bears.id,
          'name' => 'Bears'
        },
        {
          'id' => seahawks.id,
          'name' => 'Seahawks'
        }
      ]
    )
  end
end
