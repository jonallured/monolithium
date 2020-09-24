require 'rails_helper'

describe 'GET /api/v1/ping' do
  it 'returns the current time' do
    get '/api/v1/ping', as: :json
    expect(response.status).to eq 200
    expect(response.body).to eq Time.now.to_i.to_s
  end
end
