class QuestionChannel < ApplicationCable::Channel
  def follow
    stream_from "question_channel_#{params[:question_id]}"
  end
end
