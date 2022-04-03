require 'rails_helper'

feature 'User can register account', %q{
  for writing questions and answers
} do
  scenario 'User register his account' do
    visit new_user_registration_path
    fill_in 'Email', with: 'user@test.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'

    click_on 'Sign up'
    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario 'User register his account with error' do
    visit new_user_registration_path
    click_on 'Sign up'

    expect(page).to have_content "Email can't be blank"
  end
end