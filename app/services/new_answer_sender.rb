class NewAnswerSender
  def send_new_answer(answer)
    user_for_notification(answer).each do |user|
      DigestMailer.new_answer(user, answer).deliver_later
    end
  end

  private

  def user_for_notification(answer)
    Subscription.where(subscriptionable: answer.question).where.not(user_id: answer.user_id).map(&:user)
  end
end