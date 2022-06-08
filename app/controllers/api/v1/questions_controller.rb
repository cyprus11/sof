class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :find_question, only: %i[update destroy]
  before_action :authorize_question, only: %i[update destroy]

  def index
    questions = Question.all
    render json: questions, each_serializer: QuestionsSerializer
  end

  def show
    question = Question.with_attached_files.find(params[:id])
    render json: question
  end

  def create
    question = current_resource_owner.questions.new(question_params)

    if question.save
      render json: question, status: 201
    else
      render_error_json(question)
    end
  end

  def update
    if @question.update(question_params)
      render json: @question, status: 201
    else
      render_error_json(@question)
    end
  end

  def destroy
    @question.destroy!

    if @question.destroyed?
      render json: { message: 'Question was deleted' }, status: 200
    else
      render json: { message: 'Question was not deleted' }, status: 400
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body,
      links_attributes: [:id, :name, :url])
  end

  def find_question
    @question = Question.find(params[:id])
  end

  def authorize_question
    authorize @question
  end
end