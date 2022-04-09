class AnswersController < ApplicationController
  before_action :set_question, only: %i[create]
  before_action :find_answer, only: %i[destroy edit update]

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user

    @answer.save
  end

  def destroy
    if current_user&.author_of?(@answer)
      @answer.destroy!
      redirect_to question_path(@answer.question), notice: 'Your answer was deleted'
    else
      redirect_to question_path(@answer.question), notice: "You can't do this"
    end
  end

  def edit

  end

  def update
    @answer.update(answer_params) if current_user&.author_of?(@answer)
  end

  private

  def set_question
    @question = Question.find_by(id: params[:question_id])
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
