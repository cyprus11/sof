require 'rails_helper'

feature 'User add comment to answer', %q{
  probably if user doesn't know answer and want
  something ask or write
} do
  given(:question) { create(:question) }
  given(:user) { create(:user) }
  given!(:answer) { create(:answer, user: user, question: question) }

  describe 'Authenticated user', js: true do
    scenario 'write comment and other user see it' do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)

        expect(page).to have_content answer.body
        expect(page).to have_link 'Comment answer'
      end

      Capybara.using_session('guest_user') do
        visit question_path(question)

        expect(page).to have_content answer.body
        expect(page).to_not have_link 'Comment answer'
      end

      Capybara.using_session('user') do
        click_on 'Comment answer'
        within ".comment-form" do
          expect(page).to have_content "New comment"
        end
        fill_in 'Comment body', with: 'Comment to answer'
        click_on 'Save comment'

        within ".answer-#{answer.id}-comments" do
          expect(page).to have_content 'Comment to answer'
        end
      end

      Capybara.using_session('guest_user') do
        within ".answer-#{answer.id}-comments" do
          expect(page).to have_content 'Comment to answer'
        end
      end
    end
  end
end