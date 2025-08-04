require "rails_helper"

describe "DELETE /api/v1/work_days/:id" do
  let(:headers) { {ApiController::CLIENT_TOKEN_HEADER => Monolithium.config.client_token} }

  context "with an invalid id" do
    it "returns 404 and an error message" do
      delete "/api/v1/work_days/invalid", headers: headers

      expect(response.status).to eq 404
      expect(response.body).to match "Couldn't find WorkDay"
    end
  end

  context "with a valid id" do
    let(:work_day) { FactoryBot.create(:work_day) }

    it "returns 200 and destroys that record" do
      delete "/api/v1/work_days/#{work_day.id}", headers: headers

      expect(response.status).to eq 200
      expect(WorkDay.where(id: work_day.id).count).to eq 0
    end
  end
end
