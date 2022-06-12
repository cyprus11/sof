class DigestMailer < ApplicationMailer

  def digest(user, questions)
    @questions = questions
    mail to: user.email, subject: 'New questions on portal'
  end

  def new_answer(user, answer)
    @answer = answer
    mail to: user.email, subject: 'New answer on a question'
  end
end
