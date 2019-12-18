require 'rails_helper'

describe PickOfTheWeekPresenter do
  describe '#text' do
    let(:season) { Season.create }
    let(:week) { Week.create season: season }
    let(:home_team) { Team.create name: 'Bears' }
    let(:away_team) { Team.create name: 'Packers' }
    let(:game1) { week.games.create home_team: home_team, away_team: away_team }

    context 'with one game' do
      it 'should return the message for that game' do
        game1.update home_score: 7, away_score: 0
        presenter = PickOfTheWeekPresenter.new week.games
        text = presenter.text

        winner = game1.winning_team.name
        loser = game1.losing_team.name
        delta = game1.delta
        expect(text).to eq "The #{winner} beat the #{loser} by #{delta}"
      end
    end

    context 'with more than one game' do
      it 'should return the message for those games' do
        game2 = week.games.create home_team: home_team, away_team: away_team
        game1.update home_score: 7, away_score: 0
        game2.update home_score: 7, away_score: 0
        presenter = PickOfTheWeekPresenter.new week.games
        text = presenter.text

        winner1 = game1.winning_team.name
        loser1 = game1.losing_team.name
        winner2 = game2.winning_team.name
        loser2 = game2.losing_team.name
        delta = game1.delta
        expect(text).to eq("A tie! The #{winner1} and #{winner2} beat the #{loser1} and #{loser2} (respectively) by #{delta}") # rubocop:disable Layout/LineLength
      end
    end
  end
end
