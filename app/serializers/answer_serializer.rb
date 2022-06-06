class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :user_id, :question_id, :files_url, :created_at, :updated_at

  has_many :links
  has_many :comments

  def files_url
    object.files.map do |file|
      {
        id: file.id,
        url: Rails.application.routes.url_helpers.rails_blob_path(file, only_path: true)
      }
    end
  end
end
