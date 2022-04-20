class AnswersController < ApplicationController
  before_action :set_question, only: %i[create]
  before_action :find_answer, only: %i[destroy edit update mark_as_best]
  before_action :redirect_to_root_page, only: %i[edit update destroy]

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user

    @answer.save
  end

  def destroy
    if @answer.destroy!
      flash[:notice] = 'Your answer was deleted'
    else
      flash[:alert] = 'Error'
    end
  end

  def mark_as_best
    redirect_to(root_path, alert: "You can't do this") and return unless current_user&.author_of?(@answer.question)

    @answer.mark_as_best!
    @other_answers = @answer.question.answers.where.not(id: @answer.id)
  end

  def edit
  end

  def update
    @answer.update(answer_params)
  end

  private

  def set_question
    @question = Question.find_by(id: params[:question_id])
  end

  def find_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, files: [],
                                    links_attributes: [:id, :name, :url, :_destroy])
  end

  def redirect_to_root_page
    redirect_to(root_path, alert: "You can't do this") and return unless current_user&.author_of?(@answer)
  end
end
