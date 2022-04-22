require 'rails_helper'

RSpec.describe Link, type: :model do
  let(:question_with_gist_link) { create(:question, :with_gist_link) }
  let(:question_with_link) { create(:question, :with_link) }

  it { should belong_to :linkable }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  it "should be a gist" do
    expect(question_with_gist_link.links.first).to be_gist
  end

  it "should not be a gist" do
    expect(question_with_link.links.first).to_not be_gist
  end

  it "should return a gist id" do
    expect(question_with_gist_link.links.first.gist_id).to eq '123456789'
  end
end
