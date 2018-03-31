require 'rails_helper'

describe 'GET /api/v1/work_weeks/:year/:number' do
  context 'without a token' do
    it 'returns an empty 404' do
      get '/api/v1/work_weeks/2017/1', as: :json

      expect(response.code).to eq '404'
      expect(response.body).to eq ''
    end
  end

  context 'with an invalid client token' do
    let(:headers) { { 'X-CLIENT-TOKEN' => 'invalid-token' } }

    it 'returns an empty 404' do
      get '/api/v1/work_weeks/2017/1', headers: headers, as: :json

      expect(response.code).to eq '404'
      expect(response.body).to eq ''
    end
  end

  context 'with a valid client token' do
    let(:headers) { { 'X-CLIENT-TOKEN' => 'shhh' } }

    context 'with an invalid year' do
      it 'returns an empty 404' do
        get '/api/v1/work_weeks/asdf/1', headers: headers, as: :json

        expect(response.code).to eq '404'
        expect(response.body).to eq ''
      end
    end

    context 'with an invalid week number' do
      it 'returns an empty 404' do
        get '/api/v1/work_weeks/2017/asdf', headers: headers, as: :json

        expect(response.code).to eq '404'
        expect(response.body).to eq ''
      end
    end

    context 'with a WorkWeek that exists' do
      it 'returns that WorkWeek' do
        monday = FactoryBot.create(
          :work_day,
          date: '2017-01-02',
          adjust_minutes: 60
        )

        tuesday = FactoryBot.create(
          :work_day,
          date: '2017-01-03',
          in_minutes: 480
        )

        wednesday = FactoryBot.create(
          :work_day,
          date: '2017-01-04',
          out_minutes: 1020
        )

        thursday = FactoryBot.create(
          :work_day,
          date: '2017-01-05',
          pto_minutes: 120
        )

        friday = FactoryBot.create(
          :work_day,
          date: '2017-01-06'
        )

        get '/api/v1/work_weeks/2017/1', headers: headers, as: :json

        expect(response.code).to eq '200'
        response_json = JSON.parse response.body

        expect(response_json).to eq(
          'work_days' => [
            {
              'id' => monday.id,
              'date' => monday.date.to_s,
              'adjust_minutes' => 60,
              'in_minutes' => monday.in_minutes,
              'out_minutes' => monday.out_minutes,
              'pto_minutes' => monday.pto_minutes
            },
            {
              'id' => tuesday.id,
              'date' => tuesday.date.to_s,
              'adjust_minutes' => tuesday.adjust_minutes,
              'in_minutes' => 480,
              'out_minutes' => tuesday.out_minutes,
              'pto_minutes' => tuesday.pto_minutes
            },
            {
              'id' => wednesday.id,
              'date' => wednesday.date.to_s,
              'adjust_minutes' => wednesday.adjust_minutes,
              'in_minutes' => wednesday.in_minutes,
              'out_minutes' => 1020,
              'pto_minutes' => wednesday.pto_minutes
            },
            {
              'id' => thursday.id,
              'date' => thursday.date.to_s,
              'adjust_minutes' => thursday.adjust_minutes,
              'in_minutes' => thursday.in_minutes,
              'out_minutes' => thursday.out_minutes,
              'pto_minutes' => 120
            },
            {
              'id' => friday.id,
              'date' => friday.date.to_s,
              'adjust_minutes' => friday.adjust_minutes,
              'in_minutes' => friday.in_minutes,
              'out_minutes' => friday.out_minutes,
              'pto_minutes' => friday.pto_minutes
            }
          ]
        )
      end
    end

    context 'with a WorkWeek that does not exist' do
      it 'creates default WorkDay records and returns that new WorkWeek' do
        get '/api/v1/work_weeks/2017/1', headers: headers, as: :json

        expect(response.code).to eq '200'
        response_json = JSON.parse response.body
        actual_dates = response_json['work_days'].map { |day| day['date'] }
        expect(actual_dates).to eq(
          ['2017-01-02', '2017-01-03', '2017-01-04', '2017-01-05', '2017-01-06']
        )
      end
    end

    context 'with a week number that spans two months' do
      it 'returns the WorkDay records from both months' do
        get '/api/v1/work_weeks/2017/5', headers: headers, as: :json

        expect(response.code).to eq '200'
        response_json = JSON.parse response.body
        actual_dates = response_json['work_days'].map { |day| day['date'] }
        expect(actual_dates).to eq(
          ['2017-01-30', '2017-01-31', '2017-02-01', '2017-02-02', '2017-02-03']
        )
      end
    end
  end
end
