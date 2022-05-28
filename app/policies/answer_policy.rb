class AnswerPolicy < ApplicationPolicy
  def edit?
    user_author_of_record?
  end

  def update?
    user_author_of_record?
  end

  def destroy?
    user_author_of_record?
  end

  def mark_as_best?
    user&.id == record.question.user_id
  end

  def new_comment?
    user.present?
  end

  def create_comment?
    new_comment?
  end

  def vote?
    user && (record.user_id != user.id)
  end

  def unvote?
    vote?
  end
end
