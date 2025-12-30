class Crud::ApacheLogFilesController < ApplicationController
  expose(:apache_log_file)
  expose(:apache_log_files) do
    ApacheLogFile.order(created_at: :desc).page(params[:page])
  end

  def show
    redirect_to crud_apache_log_file_path(ApacheLogFile.random) if random_id?
  end

  def create
    if apache_log_file.save
      flash.notice = "Apache Log File created"
      redirect_to crud_apache_log_file_path(apache_log_file)
    else
      flash.alert = apache_log_file.errors.full_messages.to_sentence
      redirect_to new_crud_apache_log_file_path
    end
  end

  def update
    if apache_log_file.update(apache_log_file_params)
      flash.notice = "Apache Log File updated"
      redirect_to crud_apache_log_file_path(apache_log_file)
    else
      flash.alert = apache_log_file.errors.full_messages.to_sentence
      redirect_to edit_crud_apache_log_file_path(apache_log_file)
    end
  end

  def destroy
    apache_log_file.destroy
    flash.notice = "Apache Log File deleted"
    redirect_to crud_apache_log_files_path
  end

  private

  def apache_log_file_params
    permitted_params = params.require(:apache_log_file).permit(ApacheLogFile.permitted_params)

    {
      dateext: permitted_params[:dateext],
      parsed_entries: MaybeJson.parse(permitted_params[:parsed_entries]),
      raw_lines: permitted_params[:raw_lines],
      state: permitted_params[:state]
    }
  end
end
