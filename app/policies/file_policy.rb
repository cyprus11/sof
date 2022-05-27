class FilePolicy < ApplicationPolicy
  def destroy?
    user_author_of_record?
  end
end
