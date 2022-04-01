require 'rails_helper'

feature 'User can see all questions', %q{
  probably he can find answer on his question
} do
  given!(:question) { create(:question) }

  scenario "User open site and see questions" do
    visit root_path
    expect(page).to have_content 'Questions'
    expect(page).to have_content question.title
  end
end