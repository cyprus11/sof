require 'rails_helper'

feature 'User delete answer', %q{
  probably his answer is bad
} do
  given(:question) { create(:question) }
  given(:other_question) { create(:question) }
  given(:user) { create(:user) }

  describe 'Authenticated user' do
    given!(:answer) { create(:answer, user: user, question: question) }
    given!(:other_answer) { create(:answer, question: other_question) }
    background { sign_in(user) }

    scenario 'tries delete his answer' do
      visit question_path(question)
      click_on 'Delete answer'

      expect(page).to have_content 'Your answer was deleted'
      expect(page).to_not have_content answer.body
    end

    scenario 'tries delete other answer' do
      visit question_path(other_question)

      expect(page).to_not have_content 'Delete answer'
    end
  end

  describe 'Authenticated user' do
    given!(:answer) { create(:answer, user: user, question: question) }

    scenario 'tries delete answer' do
      visit question_path(question)

      expect(page).to_not have_content 'Delete answer'
    end
  end
end