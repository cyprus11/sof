require 'sphinx_helper'

RSpec.describe SphinxFinder do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, user: user) }
  let!(:comment) { create(:comment, user: user, commentable: answer) }
  let(:params) { { type: '', query: ''} }
  subject { SphinxFinder.new(params) }

  context 'User find question' do
    let!(:params) { { type: 'questions', query: question.title} }
    let(:result) { subject.call }

    it 'return hash with question key and array with question', sphinx: true do
      ThinkingSphinx::Test.run do
        sleep(0.5)
        expect(result).to have_key 'question'
        expect(result['question'].first.title).to eq question.title
      end
    end
  end

  context 'User find answer' do
    let!(:params) { { type: 'answers', query: answer.body} }
    let(:result) { subject.call }

    it 'return hash with answer key and array with answer', sphinx: true do
      ThinkingSphinx::Test.run do
        expect(result).to have_key 'answer'
        expect(result['answer'].first.body).to eq answer.body
      end
    end
  end

  context 'User find comment' do
    let!(:params) { { type: 'comments', query: comment.body} }
    let(:result) { subject.call }

    it 'return hash with comment key and array with comment', sphinx: true do
      ThinkingSphinx::Test.run do
        expect(result).to have_key 'comment'
        expect(result['comment'].first.body).to eq comment.body
      end
    end
  end

  context 'User find user' do
    let!(:params) { { type: 'users', query: user.email} }
    let(:result) { subject.call }

    it 'return hash with user key and array with user', sphinx: true do
      ThinkingSphinx::Test.run do
        expect(result).to have_key 'user'
        expect(result['user'].first.email).to eq user.email
      end
    end
  end

  context 'User find all' do
    let!(:params) { { type: 'all', query: user.email} }
    let(:result) { subject.call }

    it 'return hash with user key and array with user', sphinx: true do
      ThinkingSphinx::Test.run do
        %w[user question answer comment].each do |key|
          expect(result).to have_key key
        end
      end
    end
  end

  context 'User try to find unexisting record' do
    let!(:params) { { type: 'all', query: 'it does not exist'} }
    let(:result) { subject.call }

    it 'return empty if record does not exist', sphinx: true do
      ThinkingSphinx::Test.run do
        expect(result).to be_empty
      end
    end
  end
end