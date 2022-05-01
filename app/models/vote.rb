class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true

  validates :user_id, uniqueness: { scope: %i[votable_id votable_type] }
  validates :vote_plus, inclusion: { in: [1, -1] }

  scope :agree, -> { where(vote_plus: 1) }
  scope :disagree, -> { where(vote_plus: -1) }
end
