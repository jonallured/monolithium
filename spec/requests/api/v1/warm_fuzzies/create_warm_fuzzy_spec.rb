require "rails_helper"

describe "POST /api/v1/warm_fuzzies" do
  let(:headers) { {ApiController::CLIENT_TOKEN_HEADER => Monolithium.config.client_token} }

  context "without required param" do
    let(:params) { {} }

    it "returns 400 and an error message" do
      post "/api/v1/warm_fuzzies", params: params, headers: headers

      expect(response.status).to eq 400
      expect(response.body).to match "param is missing"
    end
  end

  context "without required attributes" do
    let(:params) { {warm_fuzzy: {foo: :bar}} }

    it "returns 400 and an error message" do
      post "/api/v1/warm_fuzzies", params: params, headers: headers

      expect(response.status).to eq 400
      expect(response.body).to match "Validation failed"
    end
  end

  context "with invalid required attributes" do
    let(:params) do
      {
        warm_fuzzy: {
          author: 123,
          received_at: "invalid",
          title: 456
        }
      }
    end

    it "returns 400 and an error message" do
      post "/api/v1/warm_fuzzies", params: params, headers: headers

      expect(response.status).to eq 400
      expect(response.body).to match "Validation failed"
    end
  end

  context "with valid required attributes" do
    let(:params) do
      {
        warm_fuzzy: {
          author: "My Wife",
          received_at: Time.now,
          title: "Just Ok"
        }
      }
    end

    it "returns 201 and the json for the warm_fuzzy" do
      post "/api/v1/warm_fuzzies", params: params, headers: headers

      expect(response.status).to eq 201
      expect(response.parsed_body).to match({
        "created_at" => anything,
        "received_at" => anything, # can we do better than this?
        "author" => "My Wife",
        "id" => anything,
        "title" => "Just Ok",
        "body" => nil,
        "updated_at" => anything
      })
    end
  end

  context "with bonus attribute" do
    let(:zero_time) { Time.at(0).utc }

    let(:params) do
      {
        warm_fuzzy: {
          created_at: zero_time,
          author: "My Wife",
          received_at: Time.now,
          title: "Just Ok"
        }
      }
    end

    it "ignores bonus attributes" do
      post "/api/v1/warm_fuzzies", params: params, headers: headers

      expect(response.status).to eq 201
      expect(response.parsed_body["created_at"]).to_not eq zero_time.as_json
    end
  end

  context "with a screenshot" do
    let(:params) do
      {
        warm_fuzzy: {
          author: "My Wife",
          received_at: Time.now,
          title: "Just Ok"
        }
      }
    end

    it "adds that screenshot to the warm fuzzy record" do
      require "pry"
      binding.pry
      # params[:screenshot] = file_fixture_upload("test.png", "image/png")
      params[:warm_fuzzy][:screenshot] = Rack::Test::UploadedFile.new("spec/fixtures/test.png", "image/png")
      post "/api/v1/warm_fuzzies", params: params, headers: headers

      expect(response.status).to eq 201
    end
  end
end
