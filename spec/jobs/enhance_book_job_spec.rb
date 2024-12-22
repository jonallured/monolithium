require "rails_helper"

describe EnhanceBookJob do
  context "with an invalid book_id" do
    let(:book_id) { "invalid" }

    it "does nothing" do
      expect do
        EnhanceBookJob.new.perform(book_id)
      end.to_not raise_error
    end
  end

  context "with a valid book_id" do
    let(:book_id) { FactoryBot.create(:book).id }

    it "enhances that book with api data" do
      expect_any_instance_of(Book::Enhancer).to receive(:update_from_api).and_return(nil)
      EnhanceBookJob.new.perform(book_id)
    end
  end
end
