class QuestionsController < ApplicationController
  include Commented

  skip_before_action :authenticate_user!, only: %i[index show]
  before_action :set_question, only: %i[show destroy edit update]
  after_action :publish_question, only: :create

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
    @question.reward = Reward.new
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
    authorize @question

    @question.destroy!
    redirect_to(root_path, notice: 'Your question was deleted')
  end

  def edit
    authorize @question
  end

  def update
    authorize @question

    @question.update(question_params)
  end

  private

  def set_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [],
                                      links_attributes: [:id, :name, :url, :_destroy],
                                      reward_attributes: [:name, :file])
  end

  def publish_question
    return if @question.errors.any?
    ActionCable.server.broadcast(
      'questions',
      ApplicationController.render(
        partial: 'questions/question',
        locals: {question: @question}
        )
      )
  end
end
