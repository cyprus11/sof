class AnswersSerializer < ActiveModel::Serializer
  attributes :id, :body, :user_id, :question_id, :created_at, :updated_at
end
