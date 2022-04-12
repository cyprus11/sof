require 'rails_helper'

feature 'Question author choose best answer', %q{
  best answer should be first,
  question author can choose other answer
  as the best
} do
  given(:question) { create(:question) }
  given(:user) { question.user }
  given(:other_user) { create(:user) }
  given!(:answers) { create_list(:answer, 3, question: question, user: other_user) }

  scenario "Author of question can choose best answer", js: true do
    sign_in(user)
    visit question_path(question)
    expect(page).to have_content "Mark as best answer"

    find_all('a', text: 'Mark as best answer').last.click
    expect(page.find('#best-answer')).to have_content answers.last.body

    find_all('a', text: 'Mark as best answer').last.click
    expect(page.find('#best-answer')).to have_content answers.second.body
  end

  scenario "Not author of question can't choose best answer" do
    sign_in(other_user)
    visit question_path(question)

    expect(page).to_not have_content 'Mark as best answer'
  end
end