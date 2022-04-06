require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }

  context "author_of?" do
    let(:question) { create(:question) }
    let(:user) { question.user }
    let(:other_user) { create(:user) }

    it "should return true" do
      expect(user).to be_author_of(question)
    end

    it "should return false" do
      expect(other_user).to_not be_author_of(question)
    end
  end
end
