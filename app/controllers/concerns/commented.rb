module Commented
  extend ActiveSupport::Concern

  included do
    before_action :set_commentable, only: %i[new_comment create_comment]
    after_action :publish_comment, only: :create_comment
  end

  def new_comment
    authorize @commentable
    @comment = @commentable.comments.new

    render template: 'comments/new_comment'
  end

  def create_comment
    authorize @commentable
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user

    @comment.save

    render template: 'comments/create_comment'
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def set_commentable
    @commentable = model_klass.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def publish_comment
    return unless @comment.persisted?

    channel_id = @commentable.is_a?(Answer) ? @commentable.question_id : @commentable.id

    ActionCable.server.broadcast(
      "question_channel_#{channel_id}",
      @comment.publish
    )
  end
end