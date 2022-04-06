require 'rails_helper'

feature "User delete a question ", %q{
  If this question not actual
} do
  given!(:question) { create(:question) }
  given(:user) { question.user }
  given(:other_user) { create(:user) }

  describe "Authenticated user" do
    scenario "User tries delete his question" do
      sign_in(user)
      visit question_path(question)
      expect(page).to have_content question.body
      expect(page).to have_content question.title
      click_on 'Delete question'

      expect(page).to have_content 'Your question was deleted'
      expect(page).to_not have_content question.title
    end

    scenario "User tries delete not his question" do
      sign_in(other_user)
      visit question_path(question)

      expect(page).to_not have_content 'Your question was deleted'
      expect(page).to have_content question.title
    end
  end

  scenario "Not-authenticated user tries delete question" do
    visit question_path(question)

    expect(page).to_not have_content 'Delete question'
    expect(page).to have_content question.title
  end
end