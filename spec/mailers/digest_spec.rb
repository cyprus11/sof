require "rails_helper"

RSpec.describe DigestMailer, type: :mailer do
  describe "digest" do
    let(:user) { create(:user) }
    let(:questions) { create_list(:question, 2) }
    let(:mail) { DigestMailer.digest(user, questions) }

    it "renders the headers" do
      expect(mail.subject).to eq("New questions on portal")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["info@sof.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi! We send you a list of new questions on site. Check it right now!")
    end
  end

  describe "new_answer" do
    let(:question) { create(:question) }
    let(:user) { question.user }
    let(:answer) { create(:answer, question: question) }
    let(:mail) { DigestMailer.new_answer(user, answer) }

    it "renders the headers" do
      expect(mail.subject).to eq("New answer on a question")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["info@sof.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("There is a new answer on a question:")
      expect(mail.body.encoded).to match(question.title)
      expect(mail.body.encoded).to match(answer.body)
    end
  end
end
