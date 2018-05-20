require 'rails_helper'

describe 'POST /hooks' do
  context 'without a signature' do
    it 'returns an empty 404' do
      post '/hooks', as: :json

      expect(response.code).to eq '404'
      expect(response.body).to eq ''
      expect(Hook.count).to eq 0
    end
  end

  context 'with an invalid signature' do
    let(:headers) { { 'X-Hub-Signature' => 'invalid-signature' } }

    it 'returns an empty 404' do
      expect_any_instance_of(HooksController)
        .to receive(:compute_signature).and_return('valid-signature')
      post '/hooks', headers: headers, as: :json

      expect(response.code).to eq '404'
      expect(response.body).to eq ''
      expect(Hook.count).to eq 0
    end
  end

  context 'with a valid signature' do
    let(:headers) { { 'X-Hub-Signature' => 'valid-signature' } }

    context 'with an invalid payload' do
      it 'returns an empty 400' do
        expect_any_instance_of(HooksController)
          .to receive(:compute_signature).and_return('valid-signature')
        body = ''

        post '/hooks', params: body, headers: headers, as: :json

        expect(response.code).to eq '400'
        expect(response.body).to eq ''
        expect(Hook.count).to eq 0
      end
    end

    context 'with a valid payload' do
      it 'returns an empty 201 and creates a Hook' do
        expect_any_instance_of(HooksController)
          .to receive(:compute_signature).and_return('valid-signature')
        body = { 'key' => 'value' }

        post '/hooks', params: body, headers: headers, as: :json

        expect(response.code).to eq '201'
        expect(response.body).to eq ''
        expect(Hook.count).to eq 1
        hook = Hook.first
        expect(hook.payload).to eq body
      end
    end
  end
end
