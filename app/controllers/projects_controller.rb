class ProjectsController < ApplicationController
  expose(:projects) { Project.order(:touched_at) }
  expose(:project)

  def create
    if project.save
      redirect_to projects_path
    else
      flash[:alert] = t("projects.create_error")
      render :index
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
