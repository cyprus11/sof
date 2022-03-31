require 'rails_helper'

feature 'User can create question', %q{
  In order to get answer from a community
  I'd like to be able to ask the question
} do
  scenario 'User create question' do
    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: 'Question title'
    fill_in 'Body', with: 'my question'
    click_on 'Ask'

    expect(page).to have_content 'Your question successfully created'
    expect(page).to have_content 'Question title'
    expect(page).to have_content 'my question'
  end

  scenario 'User create error question' do
    visit questions_path
    click_on 'Ask question'
    click_on 'Ask'

    expect(page).to have_content "Title can't be blank"
  end
end