module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_voteble, only: %i[vote unvote]
  end

  def vote
    authorize @votable
    @vote = @votable.votes.new(user: current_user, vote_plus: params[:vote_plus])
    if @vote.save
      render json: { vote: @vote, vote_diff: @vote.votable.votes_result }
    else
      render_error_json
    end
  end

  def unvote
    authorize @votable
    @vote = @votable.votes.find_by(user: current_user)
    if @vote&.destroy!
      render json: { vote: @vote, vote_diff: @vote.votable.votes_result }
    else
      render_error_json
    end
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def set_voteble
    @votable = model_klass.find(params[:id])
  end

  def render_error_json
    render json: { error: "Error" }, status: :unprocessable_entity
  end
end