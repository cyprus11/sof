require 'rails_helper'

feature 'Add link to question', %q{
  in order to show code or some source
} do
  given(:user) { create(:user) }
  given(:link) { 'https://www.google.ru'}

  scenario 'user add link when create question' do
    sign_in(user)
    visit new_question_path
    fill_in 'Title', with: 'Question title'
    fill_in 'Body', with: 'my question'
    fill_in 'URL name', with: 'My url'
    fill_in 'Url', with: link

    click_on 'Ask'

    expect(page).to have_link 'My url', href: link
  end

  scenario 'user add wrong url', js: true do
    sign_in(user)
    visit new_question_path
    fill_in 'Title', with: 'Question title'
    fill_in 'Body', with: 'my question'
    fill_in 'URL name', with: 'My url'
    fill_in 'Url', with: 'www.wrong-link'

    click_on 'Ask'

    expect(page).to have_content 'URL not valid'
  end
end