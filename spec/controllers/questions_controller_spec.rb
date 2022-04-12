require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }
  let(:user) { question.user }

  describe "GET #index" do
    let!(:questions) { create_list(:question, 3) }
    before { get :index }

    it "populates an array of all questions" do
      expect(assigns(:questions)).to match_array(questions)
    end

    it "renders index view" do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end


    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe "GET #new" do
    before { login(user) }
    before { get :new }

    it "assigns a new Question to @question" do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it "renders new view" do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    before { login(user) }
    before { get :edit, params: { id: question, format: :js }, xhr: true }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end


    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe "POST #create" do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new question in the database' do
        expect { post :create, params: { question: attributes_for(:question, user_id: user.id) } }.to change(Question, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question, user_id: user.id) }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, params: { question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'with valid user' do
      let!(:question_user) { question.user }
      before { login(question_user) }

      it 'deletes a question' do
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
      end

      it 'redirect to root page' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to root_path
      end
    end

    context 'with invalid user' do
      let(:invalid_user) { create(:user) }
      let!(:question) { create(:question) }
      before { login(invalid_user) }

      it 'will not delete a question' do
        expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
      end

      it 'redirect to question page' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to root_path
      end
    end
  end

  describe 'DELETE #delete_file' do
    context 'with valid user' do
      let!(:question_with_file) { create(:question, :with_file) }
      let(:user) { question_with_file.user }
      let(:file_id) { question_with_file.files[0].id }
      before { login(user) }

      it 'deletes a file' do
        expect { delete :delete_file, params: { question_id: question_with_file.id, id: file_id, format: :js } }.to change(question_with_file.files, :count).by(-1)
      end

      it 'render delete_file template' do
        delete :delete_file, params: { question_id: question_with_file.id, id: file_id, format: :js }
        expect(response).to render_template :delete_file
      end
    end

    context 'with invalid user' do
      let(:invalid_user) { create(:user) }
      let!(:question_with_file) { create(:question, :with_file) }
      let(:file_id) { question_with_file.files[0].id }
      before { login(invalid_user) }

      it 'will not delete a file' do
        expect { delete :delete_file, params: { question_id: question_with_file.id, id: file_id, format: :js } }.to_not change(question_with_file.files, :count)
      end

      it 'redirect to root_path' do
        delete :delete_file, params: { question_id: question_with_file.id, id: file_id, format: :js }
        expect(response).to redirect_to root_path
      end
    end
  end
end
