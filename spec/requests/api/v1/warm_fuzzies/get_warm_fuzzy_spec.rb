require "rails_helper"

describe "GET /api/v1/books/:id" do
  let(:headers) { {ApiController::CLIENT_TOKEN_HEADER => Monolithium.config.client_token} }

  context "with invalid id" do
    it "returns 404" do
      get "/api/v1/books/invalid", headers: headers

      expect(response.status).to eq 404
      expect(response.body).to match "Couldn't find Book"
    end
  end

  context "with a valid id" do
    it "returns the json for that record" do
      book = FactoryBot.create(
        :book,
        finished_on: Date.today,
        format: "print",
        isbn: "9781984861337",
        pages: 144,
        title: "Guide to Midwestern Conversation"
      )

      get "/api/v1/books/#{book.id}", headers: headers

      expect(response.status).to eq 200
      expect(response.parsed_body).to match({
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

  context "with random id" do
    it "returns a random record" do
      book = FactoryBot.create(:book)
      expect(Book).to receive(:random).and_return(book)

      get "/api/v1/books/random", headers: headers

      expect(response.status).to eq 200
      expect(response.parsed_body["id"]).to eq(book.id)
    end
  end
end
