require 'rails_helper'

RSpec.describe DailyDigest do
  let(:questions) { create_list(:question, 3, created_at: 1.day.before) }
  let(:users) { questions.map(&:user) }
  let(:other_users) { create_list(:user, 2) }

  it "sends daily digest to all users" do
    (users + other_users).each { |user| expect(DigestMailer).to receive(:digest).with(user, questions).and_call_original }
    subject.send_digest
  end
end