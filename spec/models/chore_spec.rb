require "rails_helper"

describe Chore do
  describe "validation" do
    context "without required attrs" do
      it "is invalid" do
        chore = Chore.new
        expect(chore).to_not be_valid
      end
    end

    context "with required attrs" do
      it "is valid" do
        chore = Chore.new(assignee: "jon", due_days: [0], title: "Clean Up")
        expect(chore).to be_valid
      end
    end
  end
end
