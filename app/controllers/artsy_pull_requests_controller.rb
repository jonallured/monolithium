class ArtsyPullRequestsController < ApplicationController
  skip_before_action :ensure_admin
end
