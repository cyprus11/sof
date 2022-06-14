require 'rails_helper'

feature 'User can subscribe on a questions', %q{
  In order to get on email an information about
  new answers
} do
  given(:question) { create(:question) }

  scenario "Non-authenticated user can't subscribe on a question" do
    visit(question_path(question))

    expect(page).to_not have_content 'Subscribe'
    expect(page).to_not have_content 'Unsubscribe'
  end

  describe 'Authenticated user' do
    given(:user) { create(:user) }
    given(:other_user) { create(:user) }
    given(:subscription) { create(:subscription, user: other_user) }

    context 'Question author' do
      background do
        sign_in(user)
        visit questions_path
        click_on 'Ask question'
        fill_in 'Title', with: 'Question title'
        fill_in 'Body', with: 'my question'
        click_on 'Ask'
      end

      scenario 'alredy subscribed, after create question' do
        expect(page).to have_content 'Unsubscribe'
      end

      scenario 'can unsubscibe from his own answer', js: true do
        expect(page).to have_content 'Unsubscribe'
        click_on 'Unsubscribe'
        expect(page).to have_content 'Subscribe'
      end
    end

    context 'Other user' do
      background { sign_in(other_user) }

      scenario 'can subscribe on a question', js: true do
        visit question_path(question)
        expect(page).to have_content 'Subscribe'
        click_on 'Subscribe'
        expect(page).to have_content 'Unsubscribe'
      end

      scenario 'can unsubscribe from a question', js: true do
        visit question_path(subscription.question)
        expect(page).to have_content 'Unsubscribe'
        click_on 'Unsubscribe'
        expect(page).to have_content 'Subscribe'
      end
    end
  end
end