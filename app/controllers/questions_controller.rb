class QuestionsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]
  before_action :set_question, only: %i[show destroy edit update]
  before_action :redirect_to_root_page, only: %i[edit update destroy]

  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.new
    @answer.links.new
  end

  def new
    @question = current_user.questions.new
    @question.links.new
  end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      redirect_to @question, notice: 'Your question successfully created'
    else
      render :new
    end
  end

  def destroy
    @question.destroy!
    redirect_to(root_path, notice: 'Your question was deleted')
  end

  def edit
  end

  def update
    @question.update(question_params)
  end

  private

  def set_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [],
                                      links_attributes: [:name, :url])
  end

  def redirect_to_root_page
    redirect_to(root_path, alert: "You can't do this") and return unless current_user&.author_of?(@question)
  end
end
