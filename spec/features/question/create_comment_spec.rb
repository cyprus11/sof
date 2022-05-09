require 'rails_helper'

feature 'User add comment to question', %q{
  probably if user doesn't know answer and want
  something ask or write
} do
  given(:question) { create(:question) }
  given(:user) { create(:user) }

  describe 'Authenticated user', js: true do
    scenario 'write comment and other user see it' do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)

        expect(page).to have_content question.body
        expect(page).to have_link 'Add comment to question'
      end

      Capybara.using_session('guest_user') do
        visit question_path(question)

        expect(page).to have_content question.body
        expect(page).to_not have_link 'Add comment to question'
      end

      Capybara.using_session('user') do
        click_on 'Add comment to question'
        within ".comment-form" do
          expect(page).to have_content "New comment"
        end
        fill_in 'Comment body', with: 'Comment to question'
        click_on 'Save comment'

        within ".question-#{question.id}-comments" do
          expect(page).to have_content 'Comment to question'
        end
      end

      Capybara.using_session('guest_user') do
        within ".question-#{question.id}-comments" do
          expect(page).to have_content 'Comment to question'
        end
      end
    end
  end
end