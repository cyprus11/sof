class AnswersController < ApplicationController
  before_action :set_question, only: %i[new create]

  def new
    @answer = @question.answers.new
  end

  def create
    @question.answers.create(answer_params)
    redirect_to question_path(@question)
  end

  private

  def set_question
    @question = Question.find_by(id: params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, :question)
  end
end
