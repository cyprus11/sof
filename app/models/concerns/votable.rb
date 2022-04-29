module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :destroy, as: :votable
  end

  def votes_result
    votes.agree.size - votes.disagree.size
  end

  def vote_plus?(user)
    votes.where(user: user)&.first&.vote_plus
  end

  def voted?(user)
    Vote.find_by(votable: self, user: user)
  end
end