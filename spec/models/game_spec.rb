require 'rails_helper'

describe Game do
  let(:home_team) { Team.create }
  let(:away_team) { Team.create }

  describe "#winning_team" do
    context "when the home team wins" do
      it "returns the home team" do
        game = Game.create home_team: home_team, away_team: away_team,
          home_score: 7, away_score: 0
        expect(game.winning_team).to eq home_team
      end
    end

    context "when the away team wins" do
      it "returns the away team" do
        game = Game.create home_team: home_team, away_team: away_team,
          home_score: 0, away_score: 7
        expect(game.winning_team).to eq away_team
      end
    end

    context "with incomplete game" do
      it "returns nil" do
        game = Game.create
        expect(game.winning_team).to eq nil
      end
    end
  end

  describe "#losing_team" do
    context "when the home team wins" do
      it "returns the away team" do
        game = Game.create home_team: home_team, away_team: away_team,
          home_score: 7, away_score: 0
        expect(game.losing_team).to eq away_team
      end
    end

    context "when the away team wins" do
      it "returns the home team" do
        game = Game.create home_team: home_team, away_team: away_team,
          home_score: 0, away_score: 7
        expect(game.losing_team).to eq home_team
      end
    end

    context "with incomplete game" do
      it "returns nil" do
        game = Game.create
        expect(game.losing_team).to eq nil
      end
    end
  end

  describe "#delta" do
    context "home team scores more" do
      it "returns a positive number" do
        game = Game.create home_score: 7, away_score: 0
        expect(game.delta).to eq 7
      end
    end

    context "away team scores more" do
      it "returns a positive number" do
        game = Game.create home_score: 0, away_score: 7
        expect(game.delta).to eq 7
      end
    end

    context "with incomplete game" do
      it "returns nil" do
        game = Game.create
        expect(game.delta).to eq nil
      end
    end
  end

  describe "#complete?" do
    subject { game.complete? }

    context "with no scores" do
      let(:game) { Game.create }
      it { should eq false }
    end

    context "with scores" do
      let(:game) { Game.create home_score: 7, away_score: 0 }
      it { should eq true }
    end
  end

  describe "#teams" do
    context "with no teams" do
      it "returns an empty array" do
        game = Game.create
        expect(game.teams).to eq []
      end
    end

    context "with one team" do
      it "returns just that one team" do
        game = Game.create home_team: home_team
        expect(game.teams).to eq [home_team]
      end
    end

    context "with two teams" do
      it "returns both teams" do
        game = Game.create home_team: home_team, away_team: away_team
        expect(game.teams).to eq [home_team, away_team]
      end
    end
  end
end
