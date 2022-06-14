class NotificationsMailer < ApplicationMailer

  def new_answer(user, answer)
    @answer = answer
    mail to: user.email, subject: 'New answer on a question'
  end
end
