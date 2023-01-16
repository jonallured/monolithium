class ProjectsController < ApplicationController
  expose(:projects) { Project.order(:touched_at) }
  expose(:project)

  def create
    if project.save
      redirect_to projects_path
    else
      flash[:error] = 'Something went wrong - project not created!'
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
