require 'rails_helper'

RSpec.describe NewAnswerJob, type: :job do
  let(:service) { double('NewAnswerSender') }
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }

  before do
    allow(NewAnswerSender).to receive(:new).and_return(service)
  end

  it 'calls NewAnswerSender#send_new_answer' do
    expect(service).to receive(:send_new_answer).with(answer)
    NewAnswerJob.perform_now(answer)
  end
end
