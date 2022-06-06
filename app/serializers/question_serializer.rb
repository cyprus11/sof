class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :created_at, :updated_at, :short_title, :files_url
  has_many :answers
  belongs_to :user
  has_many :comments

  def short_title
    object.title.truncate(7)
  end

  def files_url
    object.files.map do |file|
      {
        id: file.id,
        url: Rails.application.routes.url_helpers.rails_blob_path(file, only_path: true)
      }
    end
  end
end
