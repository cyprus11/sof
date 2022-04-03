require 'rails_helper'

feature 'User can create answer', %q{
  get an answer on a question
} do
  given(:question) { create(:question) }
  given(:user) { create(:user) }

  describe 'Authenticated user' do
    background { sign_in(user) }

    scenario 'visit page with question and print answer' do
      visit question_path(question)
      fill_in 'Body', with: 'answer on question'
      click_on 'Publish'

      expect(page).to have_content question.title
      expect(page).to have_content question.body
      expect(page).to have_content 'answer on question'
    end
  end

  scenario 'Unauthenticated user visit page with question and print answer' do
    visit question_path(question)

    expect(page).to_not have_content 'Body'
    expect(page).to_not have_content 'Publish'
  end
end