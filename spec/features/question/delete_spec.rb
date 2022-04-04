require 'rails_helper'

feature "Authenticated user delete a question ", %q{
  If this question not actual
} do
  given!(:question) { create(:question) }
  given(:user) { question.user }
  given(:other_user) { create(:user) }

  scenario "User tries delete his question" do
    sign_in(user)
    visit question_path(question)
    click_on 'Delete question'

    expect(page).to have_content 'Your question was deleted'
  end

  scenario "User tries delete not his question" do
    sign_in(other_user)
    visit question_path(question)

    expect(page).to_not have_content 'Your question was deleted'
  end
end