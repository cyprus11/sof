class NewAnswerJob < ApplicationJob
  queue_as :default

  def perform(answer)
    NewAnswerSender.new.send_new_answer(answer)
  end
end
