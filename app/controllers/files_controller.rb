class FilesController < ApplicationController
  before_action :find_record

  def destroy
    authorize @record

    @file_id = params[:id]
    @record.files.find(@file_id).purge
  end

  private

  def find_record
    @record = ActiveStorage::Attachment.find_by(blob_id: params[:id]).record
  end
end