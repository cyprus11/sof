class SubscriptionPolicy < ApplicationPolicy
  def create?
    user.present? && Subscription.find_by(question: record, user: user).nil?
  end

  def destroy?
    user_author_of_record?
  end
end
