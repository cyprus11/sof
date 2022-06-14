require 'rails_helper'

RSpec.describe SubscriptionPolicy, type: :policy do
  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let(:question_author) { question.user }
  let(:subscription) { create(:subscription, question: question, user: user) }

  subject { described_class }

  permissions :create? do
    it 'allow to subscribe on a question' do
      expect(subject).to permit(user, question)
    end

    it 'deny subscribe on a question for quests' do
      expect(subject).to_not permit(nil, question)
    end

    it 'deny subscribe on a question if user already has a subscription' do
      expect(subject).to_not permit(question_author, question)
    end
  end

  permissions :destroy? do
    it 'allow to unsubscribe from a question' do
      expect(subject).to permit(user, subscription)
    end

    it 'deny unsubscribe from a question for quests' do
      expect(subject).to_not permit(nil, subscription)
    end
  end
end
