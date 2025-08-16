class Crud::ProjectsController < ApplicationController
  expose(:project)
  expose(:projects) do
    Project.order(created_at: :desc).page(params[:page])
  end

  def show
    redirect_to crud_project_path(Project.random) if random_id?
  end

  def create
    if project.save
      flash.notice = "Project created"
      redirect_to crud_project_path(project)
    else
      flash.alert = project.errors.full_messages.to_sentence
      redirect_to new_crud_project_path
    end
  end

  def update
    if project.update(project_params)
      flash.notice = "Project updated"
      redirect_to crud_project_path(project)
    else
      flash.alert = project.errors.full_messages.to_sentence
      redirect_to edit_crud_project_path(project)
    end
  end

  def destroy
    project.destroy
    flash.notice = "Project deleted"
    redirect_to crud_projects_path
  end

  private

  def project_params
    params.require(:project).permit(Project.permitted_params)
  end
end
