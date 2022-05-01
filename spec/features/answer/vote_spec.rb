require 'rails_helper'

feature "User voute for answer", %q{
  in order to show good answer or bad
} do
  given(:question) { create(:question) }
  given(:user) { create(:user) }
  given!(:answer) { create(:answer, user: user, question: question) }
  given(:vote_user) { create(:user) }


  describe 'Authenticated user', js: true do
    scenario 'vote for answer as good' do
      sign_in(vote_user)
      visit question_path(question)
      expect(page).to have_content answer.body
      expect(page).to have_link '+'
      expect(page).to have_link '-'

      click_on '+'
      expect(page).to have_content 'You choice: +'
      expect(page).to have_link 'Decline your vote'
      expect(page).to_not have_link '+'
      expect(page).to_not have_link '-'
      expect(page).to have_content 'All votes diff: 1'
    end

    scenario 'vote for answer as bad' do
      sign_in(vote_user)
      visit question_path(question)
      expect(page).to have_content answer.body
      expect(page).to have_link '+'
      expect(page).to have_link '-'

      click_on '-'
      expect(page).to have_content 'You choice: -'
      expect(page).to have_link 'Decline your vote'
      expect(page).to_not have_link '+'
      expect(page).to_not have_link '-'
      expect(page).to have_content 'All votes diff: -1'
    end

    scenario 'can decline his vote' do
      sign_in(vote_user)
      visit question_path(question)
      expect(page).to have_content answer.body
      expect(page).to have_link '+'
      expect(page).to have_link '-'

      click_on '-'
      expect(page).to have_content 'You choice: -'
      expect(page).to have_link 'Decline your vote'
      expect(page).to_not have_link '+'
      expect(page).to_not have_link '-'
      expect(page).to have_content 'All votes diff: -1'

      click_on 'Decline your vote'
      expect(page).to_not have_content 'You choice: -'
      expect(page).to_not have_link 'Decline your vote'
      expect(page).to_not have_content '-1'
      expect(page).to have_link '+'
      expect(page).to have_link '-'
    end

    scenario "can't vote for his answer" do
      sign_in(user)
      visit question_path(question)
      expect(page).to have_content answer.body
      expect(page).to_not have_link '+'
      expect(page).to_not have_link '-'
    end
  end

  scenario "Unauthenticated user can't vote for answer" do
    visit question_path(question)
    expect(page).to have_content answer.body
    expect(page).to_not have_link '+'
    expect(page).to_not have_link '-'
  end
end