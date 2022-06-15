class DigestMailer < ApplicationMailer

  def digest(user, questions)
    @questions = questions
    mail to: user.email, subject: 'New questions on portal'
  end
end
