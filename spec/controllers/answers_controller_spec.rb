require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:user) { create(:user) }
  before { login(user) }

  describe "POST #create" do
    context "with valid data" do
      it 'saves a new answer in the database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js } }.to change(Answer, :count).by(1)
      end

      it 'redirects to question show view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js }
        expect(response).to render_template :create
      end
    end

    context "with invalid data" do
      it 'do not save a new answer in the database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid), format: :js } }.to_not change(Answer, :count)
      end

      it 're-render a question show template' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid), format: :js }
        expect(response).to render_template :create
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer, question: question, user: user) }

    context 'with valid user' do
      it 'deletes a question' do
        expect { delete :destroy, params: { question_id: question, id: answer } }.to change(Answer, :count).by(-1)
      end

      it 'redirect to question page' do
        delete :destroy, params: { question_id: question, id: answer }
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'with invalid user' do
      let(:invalid_user) { create(:user) }
      before { login(invalid_user) }

      it 'will not delete a question' do
        expect { delete :destroy, params: { question_id: question, id: answer } }.to_not change(Answer, :count)
      end

      it 'redirect to root page' do
        delete :destroy, params: { question_id: question, id: answer }
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "GET #edit" do
    let!(:answer) { create(:answer, question: question, user: user) }
    let(:other_user) { create(:user) }

    it 'with valid user will render edit template' do
      login(user)
      get :edit, params: { id: answer.id, format: :js }, xhr: true
      expect(response).to render_template :edit
    end

    it 'with invalid user will redirect to root_path' do
      login(other_user)
      get :edit, params: { id: answer.id, format: :js }, xhr: true
      expect(response).to redirect_to root_path
    end
  end

  describe "PUT #update" do
    let!(:answer) { create(:answer, question: question, user: user) }
    let(:other_user) { create(:user) }

    it 'with valid user will render edit template' do
      login(user)
      put :update, params: { id: answer.id, answer: { body: 'other answer' }, format: :js }
      expect(response).to render_template :update
    end

    it 'with invalid user will redirect to root_path' do
      login(other_user)
      put :update, params: { id: answer.id, answer: { body: 'other answer' }, format: :js }
      expect(response).to redirect_to root_path
    end
  end
end
