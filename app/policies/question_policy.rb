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
end
