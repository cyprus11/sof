require 'rails_helper'

feature 'User can see all his rewards', %q{
  that he get for his best answers
} do
  given(:user) { create(:user) }
  given!(:rewards) { create_list(:reward, 5, user: user) }

  scenario 'User open page with his reward' do
    sign_in(user)
    visit rewards_path
    expect(page).to have_content 'All my rewards'

    rewards.each do |reward|
      expect(page).to have_content reward.question.title
      expect(page).to have_content reward.name
    end
  end
end