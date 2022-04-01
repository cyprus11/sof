require 'rails_helper'

feature 'User can create answer', %q{
  get an answer on a question
} do
  given(:question) { create(:question) }

  scenario 'User visit page with question and print answer' do
    visit question_path(question)
    fill_in 'Body', with: 'answer on question'
    click_on 'Publish'

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to have_content 'answer on question'
  end
end