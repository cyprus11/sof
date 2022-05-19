require 'rails_helper'

feature 'User can create question', %q{
  In order to get answer from a community
  I'd like to be able to ask the question
} do
  describe 'Authenticated user' do
    given(:user) { create(:user) }
    background { sign_in(user) }

    scenario 'create question' do
      visit questions_path
      click_on 'Ask question'
      fill_in 'Title', with: 'Question title'
      fill_in 'Body', with: 'my question'
      click_on 'Ask'

      expect(page).to have_content 'Your question successfully created'
      expect(page).to have_content 'Question title'
      expect(page).to have_content 'my question'
    end

    scenario 'create error question' do
      visit questions_path
      click_on 'Ask question'
      click_on 'Ask'

      expect(page).to have_content "Title can't be blank"
    end

    scenario 'can add files to question' do
      visit questions_path
      click_on 'Ask question'
      fill_in 'Title', with: 'Question title'
      fill_in 'Body', with: 'my question'
      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Ask'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  context "multiple sessions", js: true do
    given(:user) { create(:user) }

    scenario "question appears on another user's page" do
      Capybara.using_session('user') do
        sign_in(user)
        visit questions_path
      end

      Capybara.using_session('guest_user') do
        visit questions_path
      end

      Capybara.using_session('user') do
        click_on 'Ask question'
        fill_in 'Title', with: 'Question title'
        fill_in 'Body', with: 'my question'
        click_on 'Ask'

        expect(page).to have_content 'Your question successfully created'
        expect(page).to have_content 'Question title'
        expect(page).to have_content 'my question'
      end

      Capybara.using_session('guest_user') do
        expect(page).to have_content 'Question title'
      end
    end

  end

  scenario 'Nonauthenticated user create question' do
    visit new_question_path

    expect(page).to have_content "Sign in"
  end
end