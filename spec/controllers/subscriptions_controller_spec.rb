require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }

  describe "POST #create" do
    it "returns http success" do
      login(user)
      post :create, params: { question_id: question.id }, format: :js
      expect(response).to have_http_status 201
    end

    it "returns https failure" do
      post :create, params: { question_id: question.id }, format: :js
      expect(response).to have_http_status 401
    end
  end

  describe "DELETE #destroy" do
    let(:subscription) { create(:subscription, question: question, user: user) }

    it "returns http success" do
      login(user)
      delete :destroy, params: { id: subscription.id }, format: :js
      expect(response).to have_http_status 200
    end

    it "returns https failure" do
      delete :destroy, params: { id: subscription.id }, format: :js
      expect(response).to have_http_status 401
    end
  end

end
