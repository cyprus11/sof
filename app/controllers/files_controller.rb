class FilesController < ApplicationController
  before_action :find_record
  before_action :redirect_to_root_page

  def destroy
    @file_id = params[:id]
    @record.files.find(@file_id).purge
  end

  private

  def find_record
    @record = ActiveStorage::Attachment.find_by(blob_id: params[:id]).record
  end

  def redirect_to_root_page
    redirect_to(root_path, alert: "You can't do this") and return unless current_user&.author_of?(@record)
  end
end