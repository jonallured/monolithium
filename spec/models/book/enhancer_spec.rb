require "rails_helper"

describe Book::Enhancer do
  describe "#update_from_api" do
    let(:book) do
      FactoryBot.create(
        :book,
        isbn: "123456789",
        pages: nil,
        title: nil
      )
    end

    before do
      expect(OpenLibraryApi).to receive(:get_book).and_return(api_data)
    end

    context "with nil api data" do
      let(:api_data) { nil }

      it "does nothing" do
        book.enhancer.update_from_api

        expect(book.isbn).to eq "123456789"
        expect(book.pages).to eq nil
        expect(book.title).to eq nil
      end
    end

    context "with complete api data" do
      let(:api_data) do
        {
          "isbn_13" => ["123-456-789"],
          "number_of_pages" => 7,
          "title" => "Very Short Book"
        }
      end

      it "updates the book with that api data" do
        book.enhancer.update_from_api

        expect(book.isbn).to eq "123-456-789"
        expect(book.pages).to eq 7
        expect(book.title).to eq "Very Short Book"
      end
    end
  end
end
