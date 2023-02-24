class ArtsyViewerController < ApplicationController
  skip_before_action :ensure_admin
  layout "artsy_viewer"
end
