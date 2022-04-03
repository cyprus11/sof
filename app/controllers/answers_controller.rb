class AnswersController < ApplicationController
  before_action :set_question, only: %i[create]

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user

    @answer.save
    redirect_to question_path(@question)
  end

  private

  def set_question
    @question = Question.find_by(id: params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, :user_id)
  end
end
