# Preview all emails at http://localhost:3000/rails/mailers/digest
class DigestPreview < ActionMailer::Preview
  def digest
    DigestMailer.digest
  end
end
