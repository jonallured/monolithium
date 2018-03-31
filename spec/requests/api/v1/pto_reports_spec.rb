require 'rails_helper'

describe 'GET /api/v1/pto_reports' do
  context 'without a token' do
    it 'returns an empty 404' do
      get '/api/v1/pto_reports', as: :json

      expect(response.code).to eq '404'
      expect(response.body).to eq ''
    end
  end

  context 'with an invalid client token' do
    let(:headers) { { 'X-CLIENT-TOKEN' => 'invalid-token' } }

    it 'returns an empty 404' do
      get '/api/v1/pto_reports', headers: headers, as: :json

      expect(response.code).to eq '404'
      expect(response.body).to eq ''
    end
  end

  context 'with a valid client token' do
    let(:headers) { { 'X-CLIENT-TOKEN' => 'shhh' } }

    context 'with no reports' do
      it 'returns an empty array' do
        get '/api/v1/pto_reports', headers: headers, as: :json

        expect(response.code).to eq '200'
        response_json = JSON.parse(response.body)
        expect(response_json).to eq([])
      end
    end

    context 'with a report' do
      it 'returns that report' do
        FactoryBot.create(
          :work_day,
          date: '2017-01-02',
          pto_minutes: 480
        )

        get '/api/v1/pto_reports', headers: headers, as: :json

        expect(response.code).to eq '200'
        response_json = JSON.parse(response.body)
        expect(response_json).to eq(
          [
            {
              'year' => 2017,
              'ytd_minutes' => 480,
              'all_minutes' => 480,
              'pto_days' => [
                { 'date' => '2017-01-02', 'minutes' => 480 }
              ]
            }
          ]
        )
      end
    end

    context 'with a couple reports' do
      it 'returns those reports' do
        FactoryBot.create(
          :work_day,
          date: '2016-01-01',
          pto_minutes: 240
        )

        FactoryBot.create(
          :work_day,
          date: '2017-01-02',
          pto_minutes: 480
        )

        FactoryBot.create(
          :work_day,
          date: '2018-01-01',
          pto_minutes: 360
        )

        get '/api/v1/pto_reports', headers: headers, as: :json

        expect(response.code).to eq '200'
        response_json = JSON.parse(response.body)
        expect(response_json.count).to eq 3
      end
    end
  end
end
