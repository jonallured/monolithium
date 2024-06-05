class CrankChamp::LeaderboardController < ApplicationController
  skip_before_action :ensure_admin

  expose(:crank_counts) do
    CrankCount.for_leaderboard
  end
end
