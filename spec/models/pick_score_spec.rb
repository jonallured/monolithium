require 'rails_helper'

describe PickScore do
  let(:home_team) { Team.create }
  let(:away_team) { Team.create }
  let(:season) { Season.create }
  let(:week) { Week.create season: season }

  before do
    week.games.create(
      home_team: home_team,
      away_team: away_team,
      home_score: 7,
      away_score: 0
    )
  end

  context 'when Rando loses and the Character wins' do
    it 'returns the score delta' do
      RandomPick.create team: away_team, week: week
      pick = Pick.create team: home_team, week: week
      score = PickScore.for(pick)
      expect(score).to eq 7
    end
  end

  context 'when both Rando and the Character lose' do
    it 'returns the score delta as a loss' do
      RandomPick.create team: away_team, week: week
      pick = Pick.create team: away_team, week: week
      score = PickScore.for(pick)
      expect(score).to eq(-7)
    end
  end

  context 'when both Rando and the Character win' do
    it 'returns 0' do
      RandomPick.create team: home_team, week: week
      pick = Pick.create team: home_team, week: week
      score = PickScore.for(pick)
      expect(score).to eq 0
    end
  end

  context 'when Rando wins and the Character loses' do
    it 'returns the score delta as a loss' do
      RandomPick.create team: home_team, week: week
      pick = Pick.create team: away_team, week: week
      score = PickScore.for(pick)
      expect(score).to eq(-7)
    end
  end

  context "when the game hasn't happened yet" do
    it 'returns 0' do
      Game.first.update home_score: nil, away_score: nil
      pick = Pick.create team: home_team, week: week
      score = PickScore.for(pick)
      expect(score).to eq 0
    end
  end
end
