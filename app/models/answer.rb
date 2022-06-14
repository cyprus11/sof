class Answer < ApplicationRecord
  include Votable
  include Commentable

  belongs_to :question
  belongs_to :user
  has_many :links, dependent: :destroy, as: :linkable

  has_many_attached :files

  validates :body, presence: true
  validates_associated :links

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  after_create :send_notification_to_subscribers

  def mark_as_best!
    question.update(best_answer: self)
    if question.reward.present?
      question.reward.update(user: user)
    end
  end

  private

  def send_notification_to_subscribers
    NewAnswerJob.perform_later(self)
  end

end
