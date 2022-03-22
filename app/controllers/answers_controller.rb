class AnswersController < ApplicationController
  before_action :set_question, only: :new

  def new
    @answer = @question.answers.new
  end

  private

  def set_question
    @question = Question.find_by(id: params[:question_id])
  end
end
