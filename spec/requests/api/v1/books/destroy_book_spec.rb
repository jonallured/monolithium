require "rails_helper"

describe "DELETE /api/v1/books/:id" do
  let(:headers) { {ApiController::CLIENT_TOKEN_HEADER => Monolithium.config.client_token} }

  context "with an invalid id" do
    it "returns 404 and an error message" do
      delete "/api/v1/books/invalid", headers: headers

      expect(response.status).to eq 404
      expect(response.body).to match "Couldn't find Book"
    end
  end

  context "with a valid id" do
    let(:book) { FactoryBot.create(:book) }

    it "returns 200 and destroys that record" do
      delete "/api/v1/books/#{book.id}", headers: headers

      expect(response.status).to eq 200
      expect(Book.where(id: book.id).count).to eq 0
    end
  end
end
