require "rails_helper"

describe GiftIdea do
  describe "scopes" do
    before do
      FactoryBot.create_list :available_gift_idea, 3
      FactoryBot.create_list :claimed_gift_idea, 5
      FactoryBot.create_list :received_gift_idea, 4
    end

    describe ".available" do
      it "returns only those that are available" do
        expect(GiftIdea.available.count).to eq 3
      end
    end

    describe ".claimed" do
      it "returns only those that are claimed" do
        expect(GiftIdea.claimed.count).to eq 5
      end
    end

    describe ".received" do
      it "returns only those that are received" do
        expect(GiftIdea.received.count).to eq 4
      end
    end
  end
end
