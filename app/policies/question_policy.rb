class QuestionPolicy < ApplicationPolicy
  def edit?
    user_author_of_record?
  end

  def update?
    user_author_of_record?
  end

  def destroy?
    user_author_of_record?
  end

  def new_comment?
    user.present?
  end

  def create_comment?
    new_comment?
  end

  def subscribe?
    user.present? && record.subscriptions.where(user_id: user.id).empty?
  end

  def unsubscribe?
    user.present? && record.subscriptions.where(user_id: user.id).present?
  end
end
