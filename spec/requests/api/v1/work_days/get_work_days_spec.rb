require "rails_helper"

describe "GET /api/v1/work_days" do
  let(:headers) { {ApiController::CLIENT_TOKEN_HEADER => Monolithium.config.client_token} }

  context "without a number param" do
    let(:params) { {year: 2025} }

    it "returns a 400 and error message" do
      get "/api/v1/work_days", params: params, headers: headers

      expect(response.status).to eq 400
      expect(response.parsed_body["error"]).to eq "number is required"
    end
  end

  context "without a year param" do
    let(:params) { {number: 7} }

    it "returns a 400 and error message" do
      get "/api/v1/work_days", params: params, headers: headers

      expect(response.status).to eq 400
      expect(response.parsed_body["error"]).to eq "year is required"
    end
  end

  context "with no records for the year and number params" do
    let(:params) { {number: 7, year: 2025} }

    it "returns default records sorted by date" do
      get "/api/v1/work_days", params: params, headers: headers

      expect(response.status).to eq 200

      actual_data = response.parsed_body.map do |work_day|
        work_day.values_at(
          "date",
          "in_minutes",
          "out_minutes",
          "pto_minutes",
          "adjust_minutes"
        )
      end

      expect(actual_data).to eq([
        ["2025-02-10", nil, nil, nil, nil],
        ["2025-02-11", nil, nil, nil, nil],
        ["2025-02-12", nil, nil, nil, nil],
        ["2025-02-13", nil, nil, nil, nil],
        ["2025-02-14", nil, nil, nil, nil]
      ])
    end
  end

  context "with records for the year and number params" do
    let(:params) { {number: 7, year: 2025} }

    it "returns the json for those records" do
      [
        ["2025-02-10", 480, 960, 0, 30],
        ["2025-02-11", 480, 930, 0, 0],
        ["2025-02-12", 0, 0, 480, 0],
        ["2025-02-13", 540, 960, 0, 0],
        ["2025-02-14", 480, 1020, 0, 0]
      ].each do |work_day|
        date, in_minutes, out_minutes, pto_minutes, adjust_minutes = work_day
        created_at = rand(1..5).days.ago

        FactoryBot.create(
          :work_day,
          adjust_minutes: adjust_minutes,
          created_at: created_at,
          date: date,
          in_minutes: in_minutes,
          out_minutes: out_minutes,
          pto_minutes: pto_minutes
        )
      end

      get "/api/v1/work_days", params: params, headers: headers

      expect(response.status).to eq 200

      actual_data = response.parsed_body.map do |work_day|
        work_day.values_at(
          "date",
          "in_minutes",
          "out_minutes",
          "pto_minutes",
          "adjust_minutes"
        )
      end

      expect(actual_data).to eq([
        ["2025-02-10", 480, 960, 0, 30],
        ["2025-02-11", 480, 930, 0, 0],
        ["2025-02-12", 0, 0, 480, 0],
        ["2025-02-13", 540, 960, 0, 0],
        ["2025-02-14", 480, 1020, 0, 0]
      ])
    end
  end
end
