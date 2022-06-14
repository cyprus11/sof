# Preview all emails at http://localhost:3000/rails/mailers/notifications
class NotificationsPreview < ActionMailer::Preview
  def new_answer
    NotificationsMailer.new_answer
  end
end
