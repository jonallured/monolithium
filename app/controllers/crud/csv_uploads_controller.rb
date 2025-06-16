class Crud::CsvUploadsController < ApplicationController
  expose(:csv_upload)
  expose(:csv_uploads) do
    CsvUpload.order(created_at: :desc).page(params[:page])
  end

  def show
    redirect_to crud_csv_upload_path(CsvUpload.random) if random_id?
  end

  def create
    if csv_upload.save
      ParseCsvUploadJob.perform_later(csv_upload.id)
      flash.notice = "CSV Upload created"
      redirect_to crud_csv_upload_path(csv_upload)
    else
      flash.alert = csv_upload.errors.full_messages.to_sentence
      redirect_to new_crud_csv_upload_path
    end
  end

  def update
    if csv_upload.update(csv_upload_params)
      flash.notice = "CSV Upload updated"
      redirect_to crud_csv_upload_path(csv_upload)
    else
      flash.alert = csv_upload.errors.full_messages.to_sentence
      redirect_to edit_crud_csv_upload_path(csv_upload)
    end
  end

  def destroy
    csv_upload.destroy
    flash.notice = "CSV Upload deleted"
    redirect_to crud_csv_uploads_path
  end

  private

  def csv_upload_params
    safe_params = params.require(:csv_upload).permit(:original_filename, :parser_class_name)

    if params[:file]
      safe_params[:original_filename] = params[:file].original_filename
      safe_params[:data] = params[:file].read
    end

    safe_params
  end
end
