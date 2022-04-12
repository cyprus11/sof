require 'rails_helper'

feature 'User can edit his question', %q{
  to fix mistakes or change something else
} do
  given(:question) { create(:question) }
  given(:user) { question.user }
  given(:other_user) { create(:user) }
  given(:question_with_file) { create(:question, :with_file) }

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

    scenario 'add files to edited question' do
      sign_in(question_with_file.user)
      visit question_path(question_with_file)
      expect(page).to have_link 'rails_helper.rb'
      expect(page).to_not have_link 'spec_helper.rb'

      click_on 'Edit question'
      attach_file 'Question files', ["#{Rails.root}/spec/spec_helper.rb"]

      click_on 'Update Question'
      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'delete file from question' do
      sign_in(question_with_file.user)
      visit question_path(question_with_file)
      expect(page).to have_link 'rails_helper.rb'

      click_on 'Edit question'
      click_on 'Delete file'
      expect(page).to_not have_link 'rails_helper.rb'

      click_on 'Update Question'
      expect(page).to_not have_link 'rails_helper.rb'
    end
  end

  scenario 'Not-authenticated user can not edit question' do
      visit question_path(question)

      expect(page).to have_content question.title
      expect(page).to have_content question.body
      expect(page).to_not have_content 'Edit question'
  end
end