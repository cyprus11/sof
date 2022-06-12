require 'rails_helper'

RSpec.describe QuestionPolicy, type: :policy do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:subscription) { create(:subscription, :question_as_subscribe, user: user) }
  let(:question_with_subscription) { subscription.subscriptionable }
  let(:other_user) { create(:user) }

  subject { described_class }

  permissions :edit? do
    it 'allow edit if user is author of question' do
      expect(subject).to permit(user, question)
    end

    it 'deny edit question for not author of question' do
      expect(subject).to_not permit(other_user, question)
    end

    it 'deny edit question for quests' do
      expect(subject).to_not permit(nil, question)
    end
  end

  permissions :update? do
    it 'allow update if user is author of question' do
      expect(subject).to permit(user, question)
    end

    it 'deny update question for not author of question' do
      expect(subject).to_not permit(other_user, question)
    end

    it 'deny update question for quests' do
      expect(subject).to_not permit(nil, question)
    end
  end

  permissions :destroy? do
    it 'allow destroy if user is author of question' do
      expect(subject).to permit(user, question)
    end

    it 'deny destroy question for not author of question' do
      expect(subject).to_not permit(other_user, question)
    end

    it 'deny destroy question for quests' do
      expect(subject).to_not permit(nil, question)
    end
  end

  permissions :new_comment? do
    it 'allow new comment if user is author of question' do
      expect(subject).to permit(user, question)
    end

    it 'allow new comment to question for not author of question' do
      expect(subject).to permit(other_user, question)
    end

    it 'deny new comment to question for quests' do
      expect(subject).to_not permit(nil, question)
    end
  end

  permissions :create_comment? do
    it 'allow create comment if user is author of question' do
      expect(subject).to permit(user, question)
    end

    it 'allow create comment to question for not author of question' do
      expect(subject).to permit(other_user, question)
    end

    it 'deny create comment to question for quests' do
      expect(subject).to_not permit(nil, question)
    end
  end

  permissions :subscribe? do
    it 'allow to subscribe on a question' do
      expect(subject).to permit(other_user, question)
    end

    it 'deny subscribe on a question for quests' do
      expect(subject).to_not permit(nil, question)
    end

    it 'denysubscribe on a question if user already has a subscription' do
      expect(subject).to_not permit(user, question)
    end
  end

  permissions :unsubscribe? do
    it 'allow to unsubscribe from a question' do
      expect(subject).to permit(user, question_with_subscription)
    end

    it 'deny unsubscribe from a question for quests' do
      expect(subject).to_not permit(nil, question_with_subscription)
    end

    it 'deny unsubscribe from a question for user if he does not have a subscription' do
      expect(subject).to_not permit(other_user, question)
    end
  end
end
