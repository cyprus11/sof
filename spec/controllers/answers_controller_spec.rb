require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  describe "GET #new" do
    let(:question) { create(:question) }
    before { get :new, params: { question_id: question.id } }

    it "assigns the question" do
      expect(assigns(:question)).to eq question
    end

    it "assigns new Answer to @answer" do
      expect(assigns(:answer)).to be_a_new Answer
    end

    it "renders a new view" do
      expect(response).to render_template :new
    end
  end

end
