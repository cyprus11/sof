require 'rails_helper'

RSpec.describe QuestionChannel, type: :channel do
  it "should successfully subscribe" do
    subscribe

    expect(subscription).to be_confirmed
  end
end
