require 'sphinx_helper'

RSpec.describe SearchController, type: :controller do
  let(:user) { create(:user) }
  let(:params) { { type: 'users', query: user.email } }

  describe 'GET #index' do
    it "renders index view", sphinx: true do
      ThinkingSphinx::Test.run do
        get :index, params: params
        expect(response).to render_template :index
      end
    end
  end
end