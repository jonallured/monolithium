require "rails_helper"

describe "GET /api/v1/books" do
  let(:headers) { {ApiController::CLIENT_TOKEN_HEADER => Monolithium.config.client_token} }
  let(:params) { nil }

  context "with no records" do
    it "returns an empty array" do
      get "/api/v1/books", params: params, headers: headers

      expect(response.status).to eq 200
      expect(response.parsed_body).to eq([])
    end
  end

  context "with a record" do
    it "returns the json for that record" do
      book = FactoryBot.create(
        :book,
        finished_on: Date.today,
        format: "print",
        isbn: "9781984861337",
        pages: 144,
        title: "Guide to Midwestern Conversation"
      )

      get "/api/v1/books", params: params, headers: headers

      expect(response.status).to eq 200
      expect(response.parsed_body.first).to match({
        "created_at" => anything,
        "finished_on" => Date.today.to_s,
        "format" => "print",
        "id" => book.id,
        "isbn" => "9781984861337",
        "pages" => 144,
        "title" => "Guide to Midwestern Conversation",
        "updated_at" => anything
      })
    end
  end

  context "with a page of records" do
    let(:params) { {page: 1} }

    it "returns those records with newest first" do
      oldest_book = FactoryBot.create(:book, created_at: 1.month.ago)
      middle_book = FactoryBot.create(:book, created_at: 1.week.ago)
      newest_book = FactoryBot.create(:book, created_at: 1.day.ago)

      get "/api/v1/books", params: params, headers: headers

      expect(response.status).to eq 200
      actual_ids = response.parsed_body.map { |book_json| book_json["id"] }
      expect(actual_ids).to eq([
        newest_book.id,
        middle_book.id,
        oldest_book.id
      ])
    end
  end

  context "with two pages of records" do
    let(:params) { {page: 2} }

    it "returns records for page two" do
      oldest_book = FactoryBot.create(:book, created_at: 1.month.ago)
      FactoryBot.create_list(:book, 3, created_at: 1.week.ago)

      get "/api/v1/books", params: params, headers: headers

      expect(response.status).to eq 200
      expect(response.parsed_body.first["id"]).to eq oldest_book.id
    end
  end
end
