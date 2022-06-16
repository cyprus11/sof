require 'sphinx_helper'

feature 'User can use search', %q{
  to find question, answer, comment or user
} do
  given!(:user) { create(:user) }
  given!(:other_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, user: user) }
  given!(:comment) { create(:comment, user: user, commentable: answer) }
  background { visit root_path }

  scenario 'User find question', sphinx: true do
    ThinkingSphinx::Test.run do
      within '#search_form' do
        fill_in 'query', with: question.title
        choose 'Questions'
        click_on 'Search'
      end
      expect(page).to have_content 'Question result:'
      expect(page).to have_content question.title
    end
  end

  scenario 'User find answer', sphinx: true do
    ThinkingSphinx::Test.run do
      within '#search_form' do
        fill_in 'query', with: answer.body
        choose 'Answers'
        click_on 'Search'
      end
      expect(page).to have_content 'Answer result:'
      expect(page).to have_content answer.body
    end
  end

  scenario 'User find comment', sphinx: true do
    ThinkingSphinx::Test.run do
      within '#search_form' do
        fill_in 'query', with: comment.body
        choose 'Comments'
        click_on 'Search'
      end
      expect(page).to have_content 'Comment result:'
      expect(page).to have_content comment.body
    end
  end

  scenario 'User find comment', sphinx: true do
    ThinkingSphinx::Test.run do
      within '#search_form' do
        fill_in 'query', with: user.email
        choose 'Users'
        click_on 'Search'
      end
      expect(page).to have_content 'User result:'
      expect(page).to have_content "Email: #{user.email}"
      expect(page).to_not have_content "Email: #{other_user.email}"
    end
  end

  scenario 'User find all', sphinx: true do
    ThinkingSphinx::Test.run do
      within '#search_form' do
        fill_in 'query', with: user.email
        click_on 'Search'
      end
      expect(page).to have_content 'User result:'
      expect(page).to have_content "Email: #{user.email}"
      expect(page).to have_content 'Question result:'
      expect(page).to have_content question.title
      expect(page).to have_content 'Comment result:'
      expect(page).to have_content comment.body
      expect(page).to have_content 'Answer result:'
      expect(page).to have_content answer.body
      expect(page).to_not have_content "Email: #{other_user.email}"
    end
  end
end