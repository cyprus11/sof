require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should belong_to :user }
  it { should belong_to(:best_answer).optional(true) }
  it { should accept_nested_attributes_for :links }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it "shouldn't be valid" do
    expect(Question.new(title: 'My title', body: 'Question body', links_attributes: { '0': { name: 'some name', url: 'wrong url' }})).to_not be_valid
  end

  it 'has attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
end
