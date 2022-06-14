class SubscriptionsController < ApplicationController
  def create
    question = Question.find(params[:question_id])
    authorize question.subscriptions.new
    subscription = question.subscriptions.create(user: current_user)
    render json: { link: subscription_path(subscription) }, status: 201
  end

  def destroy
    subscription = Subscription.find(params[:id])
    authorize subscription
    subscription.destroy!
    render json: { link: question_subscriptions_path(subscription.question) }, status: 200
  end
end
