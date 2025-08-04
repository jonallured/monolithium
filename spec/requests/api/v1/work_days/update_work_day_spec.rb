require "rails_helper"

describe "PUT /api/v1/work_days/:id" do
  let(:headers) { {ApiController::CLIENT_TOKEN_HEADER => Monolithium.config.client_token} }

  context "with an invalid id" do
    it "returns 404 and an error message" do
      put "/api/v1/work_days/invalid", headers: headers

      expect(response.status).to eq 404
      expect(response.body).to match "Couldn't find WorkDay"
    end
  end

  context "without required param" do
    let(:work_day) { FactoryBot.create(:work_day) }
    let(:params) { {} }

    it "returns 400 and an error message" do
      put "/api/v1/work_days/#{work_day.id}", params: params, headers: headers

      expect(response.status).to eq 400
      expect(response.body).to match "param is missing"
    end
  end

  context "with an invalid update" do
    let(:work_day) { FactoryBot.create(:work_day) }
    let(:params) { {work_day: {date: "invalid"}} }

    it "returns 400 and an error message" do
      put "/api/v1/work_days/#{work_day.id}", params: params, headers: headers

      expect(response.status).to eq 400
      expect(response.body).to match "Validation failed"
    end
  end

  context "with a valid id and update" do
    let(:work_day) { FactoryBot.create(:work_day, date: Date.today) }
    let(:params) { {work_day: {date: Date.yesterday}} }

    it "returns 200 and the updated json" do
      put "/api/v1/work_days/#{work_day.id}", params: params, headers: headers

      expect(response.status).to eq 200
      expect(response.parsed_body["date"]).to eq Date.yesterday.to_s
    end
  end

  context "with bonus attribute" do
    let(:work_day) { FactoryBot.create(:work_day) }
    let(:zero_time) { Time.at(0).utc }
    let(:params) { {work_day: {created_at: zero_time}} }

    it "ignores bonus attributes" do
      put "/api/v1/work_days/#{work_day.id}", params: params, headers: headers

      expect(response.status).to eq 200
      expect(response.parsed_body["created_at"]).to_not eq zero_time.as_json
    end
  end
end
