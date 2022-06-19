require "rails_helper"

RSpec.describe DigestMailer, type: :mailer do
  describe "digest" do
    let(:user) { create(:user) }
    let(:questions) { create_list(:question, 2) }
    let(:mail) { DigestMailer.digest(user, questions) }

    it "renders the headers" do
      expect(mail.subject).to eq("New questions on portal")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["deploy@tav-dev.tk"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi! We send you a list of new questions on site. Check it right now!")
    end
  end


end
