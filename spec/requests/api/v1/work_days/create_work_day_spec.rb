require "rails_helper"

describe "POST /api/v1/work_days" do
  let(:headers) { {ApiController::CLIENT_TOKEN_HEADER => Monolithium.config.client_token} }

  context "without required param" do
    let(:params) { {} }

    it "returns 400 and an error message" do
      post "/api/v1/work_days", params: params, headers: headers

      expect(response.status).to eq 400
      expect(response.body).to match "param is missing"
    end
  end

  context "without required attributes" do
    let(:params) { {work_day: {foo: :bar}} }

    it "returns 400 and an error message" do
      post "/api/v1/work_days", params: params, headers: headers

      expect(response.status).to eq 400
      expect(response.body).to match "Validation failed"
    end
  end

  context "with invalid required attributes" do
    let(:params) { {work_day: {date: "invalid"}} }

    it "returns 400 and an error message" do
      post "/api/v1/work_days", params: params, headers: headers

      expect(response.status).to eq 400
      expect(response.body).to match "Validation failed"
    end
  end

  context "with valid required attributes" do
    let(:params) { {work_day: {date: Date.today}} }

    it "returns 201 and the json for the work_day" do
      post "/api/v1/work_days", params: params, headers: headers

      expect(response.status).to eq 201
      expect(response.parsed_body).to match({
        "adjust_minutes" => nil,
        "created_at" => anything,
        "date" => Date.today.to_s,
        "id" => anything,
        "in_minutes" => nil,
        "out_minutes" => nil,
        "pto_minutes" => nil,
        "updated_at" => anything
      })
    end
  end

  context "with bonus attribute" do
    let(:zero_time) { Time.at(0).utc }

    let(:params) do
      {
        work_day: {
          created_at: zero_time,
          date: Date.today
        }
      }
    end

    it "ignores bonus attributes" do
      post "/api/v1/work_days", params: params, headers: headers

      expect(response.status).to eq 201
      expect(response.parsed_body["created_at"]).to_not eq zero_time.as_json
    end
  end
end
