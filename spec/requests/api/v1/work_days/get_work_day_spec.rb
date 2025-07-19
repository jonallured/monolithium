require "rails_helper"

describe "GET /api/v1/work_days/:id" do
  let(:headers) { {ApiController::CLIENT_TOKEN_HEADER => Monolithium.config.client_token} }

  context "with invalid id" do
    it "returns 404" do
      get "/api/v1/work_days/invalid", headers: headers

      expect(response.status).to eq 404
      expect(response.body).to match "Couldn't find WorkDay"
    end
  end

  context "with a valid id" do
    it "returns the json for that record" do
      work_day = FactoryBot.create(
        :work_day,
        adjust_minutes: 0,
        date: Date.today,
        in_minutes: 480,
        out_minutes: 960,
        pto_minutes: 0
      )

      get "/api/v1/work_days/#{work_day.id}", headers: headers

      expect(response.status).to eq 200
      expect(response.parsed_body).to match({
        "adjust_minutes" => 0,
        "created_at" => anything,
        "date" => Date.today.to_s,
        "id" => work_day.id,
        "in_minutes" => 480,
        "out_minutes" => 960,
        "pto_minutes" => 0,
        "updated_at" => anything
      })
    end
  end

  context "with random id" do
    it "returns a random record" do
      work_day = FactoryBot.create(:work_day)
      expect(WorkDay).to receive(:random).and_return(work_day)

      get "/api/v1/work_days/random", headers: headers

      expect(response.status).to eq 200
      expect(response.parsed_body["id"]).to eq(work_day.id)
    end
  end
end
