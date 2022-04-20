require 'rails_helper'

feature 'Add link to answer', %q{
  in order to show code or some source
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:link) { 'https://www.google.ru'}

  scenario 'user add link when create question', js: true do
    sign_in(user)
    visit question_path(question)
    fill_in 'Body', with: 'my answer'
    fill_in 'URL name', with: 'My url'
    fill_in 'Url', with: link

    click_on 'Create Answer'

    expect(page).to have_link 'My url', href: link
  end
end