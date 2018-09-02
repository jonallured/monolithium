require 'rails_helper'

describe CurrentPick do
  describe "#week_number" do
    it "returns the number of the pick's week" do
      week = Week.create number: 1
      pick = Pick.create week: week
      current_pick = CurrentPick.new pick
      expect(current_pick.week_number).to eq week.number
    end
  end

  describe "#team_id" do
    it "returns the id of the pick's team" do
      team = Team.create
      pick = Pick.create team: team
      current_pick = CurrentPick.new pick
      expect(current_pick.team_id).to eq team.id
    end
  end
end
