class CreateVotes < ActiveRecord::Migration[6.1]
  def change
    create_table :votes do |t|
      t.integer :vote_plus
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :votable, polymorphic: true
      t.index [:user_id, :votable_id, :votable_type], unique: true

      t.timestamps
    end
  end
end
