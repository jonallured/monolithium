class ProjectListController < ApplicationController
  expose(:projects) { Project.order(:touched_at) }
  expose(:project)

  def update
    project.update touched_at: Time.zone.now
    head :no_content
  end
end
