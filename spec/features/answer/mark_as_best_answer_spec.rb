require 'rails_helper'

feature 'Question author choose best answer', %{
  best answer should be first,
  question author can choose other answer
  as the best
} do
  given(:question) { create(:question) }
  given(:user) { question.user }
  given(:other_user) { create(:user) }
  given!(:first_answer) { create(:answer, question: question, user: other_user) }
  given!(:second_answer) { create(:answer, question: question, user: other_user) }

  describe "Author of question" do
    scenario "can choose best answer" do
      sign_in(user)
      visit question_path(question)
      expect(response).to have_content "Mark as best answer"

      click_on('Mark as best answer', match: :last)
      expect(find('.answer', match: :first)).to have_content second_answer.body

      click_on('Mark as best answer', match: :last)
      expect(find('.answer', match: :first)).to have_content first_answer.body
    end
  end

  scenario "Not author of question can't choose best answer" do
    sign_in(other_user)
    visit question_path(question)

    expect(page).to_not have_content 'Mark as best answer'
  end
end