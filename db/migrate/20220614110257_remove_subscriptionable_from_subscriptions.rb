class RemoveSubscriptionableFromSubscriptions < ActiveRecord::Migration[6.1]
  def up
    remove_reference :subscriptions, :subscriptionable, polymorphic: true
    remove_index :subscriptions, name: :subscription_index, if_exists: true
    add_reference :subscriptions, :question, null: false, foreign_key: true
    add_index :subscriptions, [:user_id, :question_id], unique: true
  end

  def down
    remove_reference :subscriptions, :question
    remove_index :subscriptions, [:user_id, :question_id], if_exists: true
    add_reference :subscriptions, :subscriptionable, polymorphic: true
    add_index :subscriptions, [:user_id, :subscriptionable_id, :subscriptionable_type], unique: true, name: 'subscription_index'
  end
end
