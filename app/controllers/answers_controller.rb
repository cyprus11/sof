class AnswersController < ApplicationController
  before_action :set_question, only: %i[create]
  before_action :find_answer, only: :destroy

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user

    @answer.save
    redirect_to question_path(@question)
  end

  def destroy
    if current_user == @answer.user
      @answer.destroy!
      redirect_to question_path(@answer.question), notice: 'Your answer was deleted'
    else
      redirect_to question_path(@answer.question), notice: "You can't do this"
    end
  end

  private

  def set_question
    @question = Question.find_by(id: params[:question_id])
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, :user_id)
  end
end
