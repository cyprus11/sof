class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :user
  belongs_to :best_answer, class_name: 'Answer', optional: true

  has_many_attached :files

  validates :title, :body, presence: true

  def other_answers
    self.best_answer_id.present? ? answers.where.not(id: self.best_answer_id) : answers
  end
end
