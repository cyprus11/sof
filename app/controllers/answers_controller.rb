class AnswersController < ApplicationController
  include Voted
  include Commented

  before_action :set_question, only: %i[create]
  before_action :find_answer, only: %i[destroy edit update mark_as_best]
  before_action :authorize_answer, only: %i[destroy mark_as_best edit update]
  after_action :publish_answer, only: :create
  after_action :send_notification_to_subscribers, only: :create

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

  def publish_answer
    ActionCable.server.broadcast(
      "question_channel_#{@answer.question_id}",
      {
        id: @answer.id,
        body: @answer.body,
        files: @answer.files.map { |file| { name: file.filename.to_s, url: url_for(file) } },
        links: @answer.links.map { |link| { name: link.name, url: link.url } },
        user_id: @answer.user_id,
        question_author_id: @answer.question.user_id,
        type: 'answer'
      }
    )
  end

  def authorize_answer
    authorize @answer
  end

  def send_notification_to_subscribers
    return unless @answer.persisted?

    NewAnswerJob.perform_later(@answer)
  end
end
