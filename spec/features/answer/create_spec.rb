require 'rails_helper'

feature 'User can create answer', %q{
  get an answer on a question
} do
  given(:question) { create(:question) }
  given(:user) { create(:user) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'visit page with question and print answer' do
      fill_in 'Body', with: 'answer on question'
      click_on 'Create Answer'

      expect(page).to have_content question.title
      expect(page).to have_content question.body

      within '.answers' do
        expect(page).to have_content 'answer on question'
      end
    end

    scenario 'visit page with question and print error answer' do
      click_on 'Create Answer'

      expect(page).to have_content "Body can't be blank"
    end

    scenario 'can add files to answer' do
      fill_in 'Body', with: 'answer on question'
      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Create Answer'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  scenario 'Unauthenticated user visit page with question and print answer' do
    visit question_path(question)

    expect(page).to_not have_content 'Body'
    expect(page).to_not have_content 'Create Answer'
  end
end