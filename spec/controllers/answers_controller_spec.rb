require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }

  describe "GET #new" do
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

  describe "POST #create" do
    context "with valid data" do
      it 'saves a new answer in the database' do
        expect { post :create, params: { question_id: question.id, answer: { body: "myBody", question_id: question.id } } }.to change(Answer, :count).by(1)
      end

      it 'redirects to question show view' do
        post :create, params: { question_id: question.id, answer: { body: "myBody", question_id: question.id } }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context "with invalid data" do

    end
  end

end
