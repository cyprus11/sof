class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  has_many_attached :files

  validates :body, presence: true

  def mark_as_best!
    question.update(best_answer: self)
  end
end
