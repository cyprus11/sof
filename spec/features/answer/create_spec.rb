require 'rails_helper'

feature 'User can create answer', %q{
  get an answer on a question
} do
  given(:question) { create(:question) }
  given(:user) { create(:user) }

  describe 'Authenticated user', js: true do
    background { sign_in(user) }

    scenario 'visit page with question and print answer' do
      visit question_path(question)
      fill_in 'Body', with: 'answer on question'
      click_on 'Create Answer'

      expect(page).to have_content question.title
      expect(page).to have_content question.body

      within '.answers' do
        expect(page).to have_content 'answer on question'
      end
    end

    scenario 'visit page with question and print error answer' do
      visit question_path(question)
      click_on 'Create Answer'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user visit page with question and print answer' do
    visit question_path(question)

    expect(page).to_not have_content 'Body'
    expect(page).to_not have_content 'Create Answer'
  end
end