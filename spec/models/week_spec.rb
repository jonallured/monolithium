require 'rails_helper'

describe Week do
  let(:home_team) { Team.create }
  let(:away_team) { Team.create }
  let(:week) { Week.create season: Season.create }

  before do
    week.games.create home_team: home_team, away_team: away_team
  end

  describe '#game_for' do
    context 'with a home team' do
      it 'returns the game for that team' do
        game = week.game_for(home_team)
        expect(game.home_team).to eq home_team
      end
    end

    context 'with an away team' do
      it 'returns the game for that team' do
        game = week.game_for(away_team)
        expect(game.away_team).to eq away_team
      end
    end
  end

  describe '#next_week' do
    let!(:season) { Season.create }
    let!(:first_week) { Week.create season: season, number: 1 }
    let!(:second_week) { Week.create season: season, number: 2 }

    context 'with the first week' do
      it 'returns the next week' do
        expect(first_week.next_week).to eq second_week
      end
    end

    context 'with the last week' do
      it 'returns nil' do
        expect(second_week.next_week).to eq nil
      end
    end
  end

  describe '#prev_week' do
    let!(:season) { Season.create }
    let!(:first_week) { Week.create season: season, number: 1 }
    let!(:second_week) { Week.create season: season, number: 2 }

    context 'with the first week' do
      it 'returns nil' do
        expect(first_week.prev_week).to eq nil
      end
    end

    context 'with the last week' do
      it 'returns the previous week' do
        expect(second_week.prev_week).to eq first_week
      end
    end
  end

  describe '#complete?' do
    subject { week.complete? }

    context 'with complete games' do
      before { week.games.first.update home_score: 7, away_score: 0 }
      it { should eq true }
    end

    context 'with incomplete games' do
      it { should eq false }
    end
  end

  describe '#active_teams' do
    it 'returns the teams for each game, sorted by id' do
      team_one = Team.create
      team_two = Team.create

      week = Week.create season: Season.create
      week.games.create home_team: team_two, away_team: team_one

      expect(week.active_teams).to eq [team_one.id, team_two.id]
    end
  end
end
