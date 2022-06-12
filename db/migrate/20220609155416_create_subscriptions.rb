class CreateSubscriptions < ActiveRecord::Migration[6.1]
  def change
    create_table :subscriptions do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :subscriptionable, polymorphic: true
      t.index [:user_id, :subscriptionable_id, :subscriptionable_type], unique: true, name: 'subscription_index'

      t.timestamps
    end
  end
end
