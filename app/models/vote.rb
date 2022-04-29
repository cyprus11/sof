class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true

  validates :user_id, uniqueness: { scope: %i[votable_id votable_type] }
  validates :vote_plus, inclusion: { in: [true, false] }

  scope :agree, -> { where(vote_plus: true) }
  scope :disagree, -> { where(vote_plus: false) }
end
