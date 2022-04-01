require 'rails_helper'

feature 'User open page with question', %{
  for reading question body
  and answerd on question
} do
  given(:question) { create(:question) }
  given!(:answer) { Answer.create(question: question, body: "Answer on question") }

  scenario 'User open question page' do
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to have_content answer.body
  end
end