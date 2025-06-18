require "rails_helper"

describe "POST /api/v1/books" do
  let(:headers) { {ApiController::CLIENT_TOKEN_HEADER => Monolithium.config.client_token} }

  context "without required param" do
    let(:params) { {} }

    it "returns 400 and an error message" do
      post "/api/v1/books", params: params, headers: headers

      expect(response.status).to eq 400
      expect(response.body).to match "param is missing"
    end
  end

  context "without required attributes" do
    let(:params) { {book: {foo: :bar}} }

    it "returns 400 and an error message" do
      post "/api/v1/books", params: params, headers: headers

      expect(response.status).to eq 400
      expect(response.body).to match "Validation failed"
    end
  end

  context "with invalid required attributes" do
    let(:params) do
      {
        book: {
          finished_on: Date.today,
          format: "invalid",
          isbn: "9781984861337"
        }
      }
    end

    it "returns 400 and an error message" do
      post "/api/v1/books", params: params, headers: headers

      expect(response.status).to eq 400
      expect(response.body).to match "Validation failed"
    end
  end

  context "with valid required attributes" do
    let(:params) do
      {
        book: {
          finished_on: Date.today,
          format: "print",
          isbn: "9781984861337"
        }
      }
    end

    it "returns 201 and the json for the book" do
      post "/api/v1/books", params: params, headers: headers

      expect(EnhanceBookJob).to have_been_enqueued.with(response.parsed_body["id"])

      expect(response.status).to eq 201
      expect(response.parsed_body).to match({
        "created_at" => anything,
        "finished_on" => Date.today.to_s,
        "format" => "print",
        "id" => anything,
        "isbn" => "9781984861337",
        "pages" => nil,
        "title" => nil,
        "updated_at" => anything
      })
    end
  end

  context "with bonus attribute" do
    let(:zero_time) { Time.at(0).utc }

    let(:params) do
      {
        book: {
          created_at: zero_time,
          finished_on: Date.today,
          format: "print",
          isbn: "9781984861337"
        }
      }
    end

    it "ignores bonus attributes" do
      post "/api/v1/books", params: params, headers: headers

      expect(response.status).to eq 201
      expect(response.parsed_body["created_at"]).to_not eq zero_time.as_json
    end
  end
end
