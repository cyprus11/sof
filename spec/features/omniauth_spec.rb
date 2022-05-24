require 'rails_helper'

feature 'User can sign in', %q{
  in order to use oauth authentication
} do
  describe 'Sign in via' do
    let(:user) { create(:user) }

    describe 'GitHub oauth' do
      background do
        visit new_user_session_path
        expect(page).to have_link 'Sign in with GitHub'
      end

      scenario 'when user exists' do
        mock_auth_hash('GitHub', user.email)
        click_on 'Sign in with GitHub'
        expect(page).to have_content 'Log out'
        expect(page).to have_content 'Successfully authenticated from GitHub account.'
      end

      scenario 'when user does not exists' do
        mock_auth_hash('GitHub')
        click_on 'Sign in with GitHub'
        expect(page).to have_content 'Log out'
        expect(page).to have_content 'Successfully authenticated from GitHub account.'
      end
    end

    describe 'Vkontakte oauth' do
      background do
        visit new_user_session_path
        expect(page).to have_link 'Sign in with Vkontakte'
      end

      scenario 'when user exists' do
        mock_auth_hash('Vkontakte', user.email)
        click_on 'Sign in with Vkontakte'
        expect(page).to have_content 'Log out'
        expect(page).to have_content 'Successfully authenticated from Vkontakte account.'
      end

      scenario 'when user does not exists' do
        mock_auth_hash('Vkontakte')
        click_on 'Sign in with Vkontakte'
        expect(page).to have_content 'Log out'
        expect(page).to have_content 'Successfully authenticated from Vkontakte account.'
      end
    end
  end

  describe 'When oauth does not return email' do
    let(:oauth) { OmniAuth.config.add_mock(:github, { 'uid' => '12345', 'provider' => 'github', 'info' => {} })}
    background do
      clear_emails
      visit new_user_session_path
      expect(page).to have_link 'Sign in with GitHub'
      oauth
      click_on 'Sign in with GitHub'
      expect(page).to have_content 'Please, type your email'
      fill_in 'Email', with: 'test@email.com'
      click_on 'Send confirmation email'
    end

    scenario 'ask user email and send an email' do
      open_email('test@email.com')
      expect(page).to have_content 'You will receive an email with instructions for how to confirm your email address in a few minutes.'
      expect(current_email).to have_link 'Confirm my account'
    end

    scenario 'do not allow user sign in unless he confirm his email' do
      visit new_user_session_path
      expect(page).to have_link 'Sign in with GitHub'
      oauth
      click_on 'Sign in with GitHub'
      expect(page).to have_content 'Please, type your email'
    end

    scenario 'after confirm email sing in user' do
      open_email('test@email.com')
      current_email.click_link 'Confirm my account'
      expect(page).to have_content 'Your email address has been successfully confirmed.'
    end
  end
end