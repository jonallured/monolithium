require "rails_helper"

describe Project do
  describe "validation" do
    it "is valid with unique name" do
      project = Project.create name: "unique"
      expect(project).to be_valid
    end

    it "is invalid with repeated name" do
      Project.create name: "unique"
      project = Project.create name: "unique"
      expect(project).to_not be_valid
    end
  end
end
