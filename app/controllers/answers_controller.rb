class AnswersController < ApplicationController
  before_action :set_question, only: %i[new create]

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.new(answer_params)

    if @answer.save
      redirect_to question_path(@question)
    else
      render :new
    end
  end

  private

  def set_question
    @question = Question.find_by(id: params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, :question)
  end
end
