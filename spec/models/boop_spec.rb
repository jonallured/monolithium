require "rails_helper"

describe Boop do
  describe "validation" do
    context "without required attrs" do
      it "is invalid" do
        boop = Boop.new
        expect(boop).to_not be_valid
      end
    end

    context "with required attrs" do
      it "is valid" do
        boop = Boop.new(display_type: "skull", number: 1)
        expect(boop).to be_valid
      end
    end

    context "with no number" do
      it "finds the next number and is valid" do
        FactoryBot.create(:boop, number: 1)
        boop = Boop.new(display_type: "skull")
        boop.validate
        expect(boop.number).to eq 2
        expect(boop).to be_valid
      end
    end
  end

  describe ".next" do
    context "with no records" do
      it "returns nil" do
        next_boop = Boop.next
        expect(next_boop).to eq nil
      end
    end

    context "with a dismissed record" do
      it "returns nil" do
        FactoryBot.create(:boop, dismissed_at: Time.now)
        next_boop = Boop.next
        expect(next_boop).to eq nil
      end
    end

    context "with a pending record" do
      it "returns that pending record" do
        pending_boop = FactoryBot.create(:boop, dismissed_at: nil)
        next_boop = Boop.next
        expect(next_boop).to eq pending_boop
      end
    end

    context "with a mix of dismissed and pending records" do
      it "returns the oldest pending record" do
        FactoryBot.create(:boop, dismissed_at: Time.now, created_at: 1.week.ago)
        FactoryBot.create(:boop, dismissed_at: nil, created_at: Time.now)
        older_pending_boop = FactoryBot.create(:boop, dismissed_at: nil, created_at: 1.day.ago)
        next_boop = Boop.next
        expect(next_boop).to eq older_pending_boop
      end
    end
  end
end
