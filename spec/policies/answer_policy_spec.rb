require 'rails_helper'

RSpec.describe AnswerPolicy, type: :policy do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:question) { create(:question) }
  let(:user_question) { create(:question, user: user) }

  subject { described_class }

  permissions :edit? do
    it 'allow edit if user is author of answer' do
      expect(subject).to permit(user, Answer.new(user: user, question: question))
    end

    it 'deny edit answer for not author of answer' do
      expect(subject).to_not permit(other_user, Answer.new(user: user, question: question))
    end

    it 'deny edit answer for quests' do
      expect(subject).to_not permit(nil, Answer.new(user: user, question: question))
    end
  end

  permissions :update? do
    it 'allow update if user is author of answer' do
      expect(subject).to permit(user, Answer.new(user: user, question: question))
    end

    it 'deny update answer for not author of answer' do
      expect(subject).to_not permit(other_user, Answer.new(user: user, question: question))
    end

    it 'deny update answer for quests' do
      expect(subject).to_not permit(nil, Answer.new(user: user, question: question))
    end
  end

  permissions :destroy? do
    it 'allow destroy if user is author of answer' do
      expect(subject).to permit(user, Answer.new(user: user, question: question))
    end

    it 'deny destroy answer for not author of answer' do
      expect(subject).to_not permit(other_user, Answer.new(user: user, question: question))
    end

    it 'deny destroy answer for quests' do
      expect(subject).to_not permit(nil, Answer.new(user: user, question: question))
    end
  end

  permissions :mark_as_best? do
    it 'allow mark answer as best only for question author' do
      expect(subject).to permit(user, Answer.new(user: other_user, question: user_question))
    end

    it 'deny mark answer as best for not author of question' do
      expect(subject).to_not permit(user, Answer.new(user: user, question: question))
    end

    it 'deny mark answer as best for guests' do
      expect(subject).to_not permit(nil, Answer.new(user: user, question: question))
    end
  end

  permissions :new_comment? do
    it 'allow new comment if user is author of answer' do
      expect(subject).to permit(user, Answer.new(user: user, question: question))
    end

    it 'allow new comment to answer for not author of answer' do
      expect(subject).to permit(other_user, Answer.new(user: user, question: question))
    end

    it 'deny new comment to answer for quests' do
      expect(subject).to_not permit(nil, Answer.new(user: user, question: question))
    end
  end

  permissions :create_comment? do
    it 'allow create comment if user is author of answer' do
      expect(subject).to permit(user, Answer.new(user: user, question: question))
    end

    it 'allow create comment to answer for not author of answer' do
      expect(subject).to permit(other_user, Answer.new(user: user, question: question))
    end

    it 'deny create comment to answer for quests' do
      expect(subject).to_not permit(nil, Answer.new(user: user, question: question))
    end
  end

  permissions :vote? do
    it 'allow vote for answer if user logged in' do
      expect(subject).to permit(user, Answer.new(user: other_user, question: question))
    end

    it 'deny vote for answer if user is author of answer' do
      expect(subject).to_not permit(user, Answer.new(user: user, question: question))
    end

    it 'deny vote for answer if user is guest' do
      expect(subject).to_not permit(nil, Answer.new(user: user, question: question))
    end
  end

  permissions :unvote? do
    it 'allow unvote for answer if user logged in' do
      expect(subject).to permit(user, Answer.new(user: other_user, question: question))
    end

    it 'deny unvote for answer if user is author of answer' do
      expect(subject).to_not permit(user, Answer.new(user: user, question: question))
    end

    it 'deny unvote for answer if user is guest' do
      expect(subject).to_not permit(nil, Answer.new(user: user, question: question))
    end
  end
end
