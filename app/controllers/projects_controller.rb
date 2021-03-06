class ProjectsController < ApplicationController
  expose(:projects) { Project.order(:touched_at) }
  expose(:project)

  def create
    if project.save
      render json: projects
    else
      head :bad_request
    end
  end

  def update
    project.update touched_at: Time.zone.now
    head :no_content
  end

  private

  def project_params
    params.require(:project).permit(:name).merge(touched_at: Time.zone.now)
  end
end
