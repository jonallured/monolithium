require "rails_helper"

describe ReadingList do
  before do
    allow(OpenLibrary).to receive(:get_book).and_return(nil)
  end

  describe "#books" do
    context "with no books" do
      it "returns an empty array" do
        reading_list = ReadingList.new
        expect(reading_list.books).to eq []
      end
    end

    context "with a few books" do
      it "returns those books" do
        books = FactoryBot.create_list :book, 3
        reading_list = ReadingList.new
        expect(reading_list.books).to eq books
      end
    end

    context "with books in other years" do
      it "does not include those books" do
        books = FactoryBot.create_list :book, 3
        FactoryBot.create :book, finished_on: Time.now - 1.year
        FactoryBot.create :book, finished_on: Time.now + 1.year
        reading_list = ReadingList.new
        expect(reading_list.books).to eq books
      end
    end

    context "ordering" do
      def make_book(attrs)
        date, pages = attrs

        FactoryBot.create(
          :book,
          finished_on: DateTime.parse(date),
          pages: pages
        )
      end

      def table_of_books(year)
        reading_list = ReadingList.new(year)

        reading_list.books.map do |book|
          [
            book.finished_on.to_s,
            book.pages
          ]
        end
      end

      it "orders books by finished date and then pages" do
        [
          ["2000-01-01", 100],
          ["2000-01-02", 100],
          ["2000-01-01", 200],
          ["2000-01-02", 300]
        ].each(&method(:make_book))

        actual = table_of_books("2000")

        expect(actual).to eq(
          [
            ["2000-01-01", 200],
            ["2000-01-01", 100],
            ["2000-01-02", 300],
            ["2000-01-02", 100]
          ]
        )
      end
    end
  end

  describe "#total_pages" do
    context "with no books" do
      it "returns zero" do
        reading_list = ReadingList.new
        expect(reading_list.total_pages).to eq 0
      end
    end

    context "with a few books" do
      it "returns the sum of those pages" do
        FactoryBot.create_list :book, 3, pages: 10
        reading_list = ReadingList.new
        expect(reading_list.total_pages).to eq 30
      end
    end

    context "with a book that has no pages" do
      it "skips that book" do
        FactoryBot.create_list :book, 3, pages: 10
        FactoryBot.create :book, pages: nil
        reading_list = ReadingList.new
        expect(reading_list.total_pages).to eq 30
      end
    end
  end

  describe "#pace" do
    context "with a year in the past" do
      it "calculates a pace as of the end of that year" do
        last_year = Time.now - 1.year
        FactoryBot.create_list :book, 10, finished_on: last_year, pages: 365
        reading_list = ReadingList.new(last_year.year)
        expect(reading_list.pace).to eq 10
      end
    end

    context "with a year in the present" do
      it "calculates a pace as of today" do
        ides_of_march = DateTime.parse("2000-03-15")

        travel_to ides_of_march do
          FactoryBot.create_list :book, 2, pages: 100
          reading_list = ReadingList.new
          expect(reading_list.pace).to eq 2.7
        end
      end
    end

    context "with a year in the future" do
      it "returns nil" do
        next_year = Time.now + 1.year
        FactoryBot.create_list :book, 10, finished_on: next_year, pages: 365
        reading_list = ReadingList.new(next_year.year)
        expect(reading_list.pace).to be_nil
      end
    end
  end
end
