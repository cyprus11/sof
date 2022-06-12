module Subscriptioned
  extend ActiveSupport::Concern

  included do
    before_action :set_subscriptionable, only: %i[subscribe unsubscribe]
    before_action :authorize_subscriptionable, only: %i[subscribe unsubscribe]
  end

  def subscribe
    @subscriptionable.subscriptions.create(user: current_user)
    render json: { link: send("unsubscribe_#{model_klass_downcase}_path", @subscriptionable) }, status: 201
  end

  def unsubscribe
    @subscriptionable.subscriptions.find_by(user_id: current_user.id).destroy!
    render json: { link: send("subscribe_#{model_klass_downcase}_path", @subscriptionable) }, status: 200
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def model_klass_downcase
    controller_name.classify.downcase
  end

  def set_subscriptionable
    @subscriptionable = model_klass.find(params[:id])
  end

  def authorize_subscriptionable
    authorize @subscriptionable
  end
end