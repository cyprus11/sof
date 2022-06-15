require 'rails_helper'

RSpec.describe NewAnswerSender do
  let(:question) { create(:question) }
  let(:users) { create_list(:user, 3) }
  let!(:subscriptions) do
    users.each do |user|
      Subscription.create(user: user, question: question)
    end
  end
  let(:answer) { create(:answer, question: question) }

  it "sends daily digest to all users" do
    (users << question.user).each { |user| expect(NotificationsMailer).to receive(:new_answer).with(user, answer).and_call_original }
    subject.send_new_answer(answer)
  end
end