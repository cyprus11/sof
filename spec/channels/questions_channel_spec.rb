require 'rails_helper'

RSpec.describe QuestionsChannel, type: :channel do
  it "should successfully subscribe" do
    subscribe

    expect(subscription).to be_confirmed
  end
end
