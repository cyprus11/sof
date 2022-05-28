require 'rails_helper'

RSpec.describe FilePolicy, type: :policy do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:question) { create(:question) }

  subject { described_class }

  permissions :destroy? do
    it 'allow delete file for author of resource' do
      expect(subject).to permit(user, Question.new(user: user))
      expect(subject).to permit(user, Answer.new(user: user, question: question))
    end

    it 'deny delete file for not author of resource' do
      expect(subject).to_not permit(other_user, Question.new(user: user))
      expect(subject).to_not permit(other_user, Answer.new(user: user, question: question))
    end

    it 'deny delete file for guest' do
      expect(subject).to_not permit(nil, Question.new(user: user))
      expect(subject).to_not permit(nil, Answer.new(user: user, question: question))
    end
  end
end
