require "rails_helper"

describe "PUT /api/v1/books/:id" do
  let(:headers) { {ApiController::CLIENT_TOKEN_HEADER => Monolithium.config.client_token} }

  context "with an invalid id" do
    it "returns 404 and an error message" do
      put "/api/v1/books/invalid", headers: headers

      expect(response.status).to eq 404
      expect(response.body).to match "Couldn't find Book"
    end
  end

  context "without required param" do
    let(:book) { FactoryBot.create(:book) }
    let(:params) { {} }

    it "returns 400 and an error message" do
      put "/api/v1/books/#{book.id}", params: params, headers: headers

      expect(response.status).to eq 400
      expect(response.body).to match "param is missing"
    end
  end

  context "with an invalid update" do
    let(:book) { FactoryBot.create(:book) }
    let(:params) { {book: {format: "invalid"}} }

    it "returns 400 and an error message" do
      put "/api/v1/books/#{book.id}", params: params, headers: headers

      expect(response.status).to eq 400
      expect(response.body).to match "Validation failed"
    end
  end

  context "with a valid id and update" do
    let(:book) { FactoryBot.create(:book, title: "Midwest Convos") }
    let(:params) { {book: {title: "Guide to Midwestern Conversation"}} }

    it "returns 200 and the updated json" do
      put "/api/v1/books/#{book.id}", params: params, headers: headers

      expect(response.status).to eq 200
      expect(response.parsed_body["title"]).to eq "Guide to Midwestern Conversation"
    end
  end

  context "with bonus attribute" do
    let(:book) { FactoryBot.create(:book, title: "Midwest Convos") }
    let(:zero_time) { Time.at(0).utc }
    let(:params) { {book: {created_at: zero_time}} }

    it "ignores bonus attributes" do
      put "/api/v1/books/#{book.id}", params: params, headers: headers

      expect(response.status).to eq 200
      expect(response.parsed_body["created_at"]).to_not eq zero_time.as_json
    end
  end
end
