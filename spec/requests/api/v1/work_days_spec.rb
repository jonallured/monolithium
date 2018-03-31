require 'rails_helper'

describe 'PATCH /api/v1/work_days/:id' do
  context 'without a token' do
    it 'returns an empty 404' do
      patch '/api/v1/work_days/1', as: :json

      expect(response.code).to eq '404'
      expect(response.body).to eq ''
    end
  end

  context 'with an invalid client token' do
    let(:headers) { { 'X-CLIENT-TOKEN' => 'invalid-token' } }

    it 'returns an empty 404' do
      patch '/api/v1/work_days/1', headers: headers, as: :json

      expect(response.code).to eq '404'
      expect(response.body).to eq ''
    end
  end

  context 'with a valid client token' do
    let(:headers) { { 'X-CLIENT-TOKEN' => 'shhh' } }

    context 'with an invalid WorkDay id' do
      it 'returns an empty 404' do
        patch '/api/v1/work_days/1', headers: headers, as: :json

        expect(response.code).to eq '404'
        expect(response.body).to eq ''
      end
    end

    context 'with a valid WorkDay id' do
      it 'updates that WorkDay and returns an empty 204' do
        work_day = FactoryBot.create :work_day

        params = { pto_minutes: 480 }
        url = "/api/v1/work_days/#{work_day.id}"
        patch url, params: params, headers: headers, as: :json

        expect(work_day.reload.pto_minutes).to eq 480
        expect(response.code).to eq '204'
        expect(response.body).to eq ''
      end
    end
  end
end
