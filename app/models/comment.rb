class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true, touch: true
  belongs_to :user

  validates :body, presence: true

  def publish
    {
      commentable_type: self.commentable_type.downcase,
      commentable_id: self.commentable_id,
      commentator: self.user.email,
      body: self.body,
      user_id: self.user_id,
      type: 'comment'
    }
  end
end
