require "rails_helper"

describe FeedbinStats do
  describe ".compute" do
    before do
      allow(FeedbinApi).to receive(:get_unread_entries).and_return(unread_entry_ids)
      allow(FeedbinApi).to receive(:get_entry).and_return(oldest_entry)
    end

    context "with no unread entries" do
      let(:unread_entry_ids) { [] }
      let(:oldest_entry) { {} }

      it "returns an empty array" do
        expect(FeedbinStats.compute).to eq []
      end
    end

    context "with an entry that has no published data" do
      let(:unread_entry_ids) { [1] }
      let(:oldest_entry) { {"id" => 1} }

      it "returns an empty array" do
        expect(FeedbinStats.compute).to eq []
      end
    end

    context "with some unread entries" do
      let(:unread_entry_ids) { [1, 2, 3] }
      let(:oldest_entry) { {"id" => 1, "published" => 10.days.ago.to_json} }

      it "returns the count and timestamp of oldest" do
        count, oldest_ago = FeedbinStats.compute

        expect(count).to eq 3
        expect(oldest_ago).to eq 10
      end
    end
  end
end
