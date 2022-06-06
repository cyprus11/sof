class Api::V1::AnswersController < Api::V1::BaseController
  before_action :find_question, only: %i[index create]
  before_action :find_answer, only: %i[show update destroy]
  before_action :authorize_answer, only: %i[update destroy]

  def index
    @answers = @question.answers
    render json: @answers, each_serializer: AnswersSerializer
  end

  def show
    render json: @answer, serializer: AnswerSerializer
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_resource_owner

    if @answer.save
      render json: @answer, status: 201
    else
      render_error_json(@answer)
    end
  end

  def update
    if @answer.update(answer_params)
      render json: @answer
    else
      render_error_json(@answer)
    end
  end

  def destroy
    @answer.destroy!

    if @answer.destroyed?
      render json: { message: 'Answer was deleted' }, status: 200
    else
      render json: { message: 'Answer was not deleted' }, status: 400
    end
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end

  def authorize_answer
    authorize @answer
  end

  def answer_params
    params.require(:answer).permit(:body,
      links_attributes: [:id, :name, :url])
  end
end