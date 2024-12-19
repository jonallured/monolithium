require "rails_helper"

describe Book do
  describe "#enhance!" do
    let(:book) { FactoryBot.create(:book, isbn: isbn) }
    let(:isbn) { "valid" }

    context "with a book that has an isbn value of none" do
      let(:isbn) { "none" }

      it "does not send api call nor update book record" do
        expect(OpenLibraryApi).to_not receive(:get_book)
        expect(book).to_not receive(:update!)
        book.enhance!
      end
    end

    context "with no api data" do
      let(:api_data) { nil }

      it "does not update the book record" do
        expect(OpenLibraryApi).to receive(:get_book).with(isbn).and_return(api_data)
        expect(book).to_not receive(:update!)
        book.enhance!
      end
    end

    context "with an api error message" do
      let(:api_data) { {error: "not found"}.to_json }

      it "does not update the book record" do
        expect(OpenLibraryApi).to receive(:get_book).with(isbn).and_return(api_data)
        expect(book).to_not receive(:update!)
        book.enhance!
      end
    end

    context "with empty api data" do
      let(:api_data) { {} }

      it "does not update the book record" do
        expect(OpenLibraryApi).to receive(:get_book).with(isbn).and_return(api_data)
        expect(book).to_not receive(:update!)
        book.enhance!
      end
    end

    context "with api data" do
      let(:api_data) do
        {
          "isbn_13" => ["123-456-789"],
          "number_of_pages" => "77",
          "title" => "Short One"
        }
      end

      it "updates the book with that api data" do
        expect(OpenLibraryApi).to receive(:get_book).with(isbn).and_return(api_data)
        book.enhance!
        book.reload

        expect(book.isbn).to eq "123-456-789"
        expect(book.pages).to eq 77
        expect(book.title).to eq "Short One"
      end
    end
  end
end
