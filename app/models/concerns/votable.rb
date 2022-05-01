module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :destroy, as: :votable
  end

  def votes_result
    votes.sum(:vote_plus)
  end

  def vote_plus?(user)
    votes.where(user: user)&.first&.vote_plus == 1
  end

  def voted?(user)
    votes.exists?(user: user)
  end
end