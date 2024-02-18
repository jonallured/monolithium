class Admin::CsvUploadsController < ApplicationController
  expose(:csv_upload)
  expose(:csv_uploads) { CsvUpload.order(created_at: :desc).page params[:page] }

  def create
    if csv_upload.save
      ParseCsvUploadJob.perform_later(csv_upload.id)
      flash.notice = "CSV Upload successfully created"
      redirect_to admin_csv_upload_path(csv_upload)
    else
      flash.alert = csv_upload.errors.full_messages.join(",")
      redirect_to new_admin_csv_upload_path
    end
  end

  private

  def csv_upload_params
    safe_params = params.require(:csv_upload).permit(:parser_class_name)
    safe_params[:original_filename] = params[:file].original_filename
    safe_params[:data] = params[:file].read
    safe_params
  end
end
