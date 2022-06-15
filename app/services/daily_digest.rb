class DailyDigest
  def send_digest
    questions = last_day_questions
    return if questions.empty?
    User.find_each(batch_size: 500) do |user|
      DigestMailer.digest(user, questions).deliver_later
    end
  end

  private

  def last_day_questions
    last_day = 1.day.before
    Question.where(created_at: last_day.beginning_of_day..last_day.end_of_day).to_a
  end
end