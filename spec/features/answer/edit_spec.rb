require 'rails_helper'

feature 'User edit answer', %q{
  to change something
} do
  given(:question) { create(:question) }
  given(:user) { create(:user) }
  given!(:answer) { create(:answer, :with_file, question: question, user: user) }
  given(:other_user) { create(:user) }

  describe "Authenticated user", js: true do

    scenario "edit his answer" do
      sign_in(user)
      visit question_path(question)

      old_answer = answer.body
      expect(page).to have_content answer.body
      expect(page).to have_content 'Edit answer'
      click_on 'Edit answer'
      fill_in 'Edited answer body', with: 'My edited answer'
      click_on 'Update Answer'

      expect(page).to have_content 'My edited answer'
      expect(page).to_not have_content old_answer
    end

    scenario "edit his answer with errors" do
      sign_in(user)
      visit question_path(question)

      expect(page).to have_content answer.body
      expect(page).to have_content 'Edit answer'
      click_on 'Edit answer'
      fill_in 'Edited answer body', with: ''
      click_on 'Update Answer'

      expect(page).to have_content "Body can't be blank"
    end

    scenario "can't edit other answer" do
      sign_in(other_user)
      visit question_path(question)

      expect(page).to_not have_content 'Edit answer'
    end

    scenario 'add files to edited question' do
      sign_in(user)
      visit question_path(question)
      expect(page).to have_link 'rails_helper.rb'
      expect(page).to_not have_link 'spec_helper.rb'

      click_on 'Edit answer'
      attach_file 'Answer files', ["#{Rails.root}/spec/spec_helper.rb"]

      click_on 'Update Answer'
      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'delete file from answer' do
      sign_in(user)
      visit question_path(question)
      expect(page).to have_link 'rails_helper.rb'

      click_on 'Edit answer'
      click_on 'Delete file'
      expect(page).to_not have_link 'rails_helper.rb'

      click_on 'Update Answer'
      expect(page).to_not have_link 'rails_helper.rb'
    end
  end

  scenario "Not-authenticated user can't edit answers" do
    visit question_path(question)

    expect(page).to_not have_content "Edit answer"
  end
end