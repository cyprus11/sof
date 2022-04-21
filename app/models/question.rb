class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :user
  belongs_to :best_answer, class_name: 'Answer', optional: true
  has_many :links, dependent: :destroy, as: :linkable
  has_one :reward, dependent: :destroy

  has_many_attached :files

  validates :title, :body, presence: true
  validates_associated :links

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :reward, reject_if: :all_blank

  def other_answers
    self.best_answer_id.present? ? answers.where.not(id: self.best_answer_id) : answers.where.not(id: nil)
  end
end
