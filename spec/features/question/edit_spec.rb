require 'rails_helper'

feature 'User can edit his question', %q{
  to fix mistakes or change something else
} do
  given(:question) { create(:question) }
  given(:user) { question.user }
  given(:other_user) { create(:user) }

  describe 'Authenticated user', js: true do
    scenario 'edit his own question' do
      sign_in(user)
      visit question_path(question)

      expect(page).to have_content question.title
      expect(page).to have_content question.body
      expect(page).to have_content 'Edit question'

      click_on 'Edit question'
      fill_in 'Title', with: 'New Title'
      fill_in 'Question body', with: 'New Body'
      click_on 'Update Question'

      expect(page).to_not have_content question.title
      expect(page).to_not have_content question.body
      expect(page).to have_content 'New Title'
      expect(page).to have_content 'New Body'
    end

    scenario 'edit his own question with error' do
      sign_in(user)
      visit question_path(question)

      expect(page).to have_content question.title
      expect(page).to have_content question.body
      expect(page).to have_content 'Edit question'

      click_on 'Edit question'
      fill_in 'Title', with: 'New Title'
      fill_in 'Question body', with: ''
      click_on 'Update Question'

      expect(page).to_not have_content "Body can't be blank"
    end

    scenario 'can not edit other question' do
      sign_in(other_user)
      visit question_path(question)

      expect(page).to have_content question.title
      expect(page).to have_content question.body
      expect(page).to_not have_content 'Edit question'
    end
  end

  scenario 'Not-authenticated user can not edit question' do
      visit question_path(question)

      expect(page).to have_content question.title
      expect(page).to have_content question.body
      expect(page).to_not have_content 'Edit question'
  end
end