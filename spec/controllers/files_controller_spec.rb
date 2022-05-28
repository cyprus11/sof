require 'rails_helper'

RSpec.describe FilesController, type: :controller do
  describe 'DELETE #destroy' do
    context 'with valid user for answer' do
      let!(:question) { create(:question) }
      let(:user) { create(:user) }
      let(:answer) { create(:answer, :with_file, user: user, question: question) }
      let(:file_id) { answer.files[0].id }
      before { login(user) }

      it 'deletes a file' do
        expect { delete :destroy, params: { id: file_id, format: :js } }.to change(answer.files, :count).by(-1)
      end

      it 'render destroy template' do
        delete :destroy, params: { id: file_id, format: :js }
        expect(response).to render_template :destroy
      end
    end

    context 'with invalid user for answer' do
      let!(:question) { create(:question) }
      let(:invalid_user) { create(:user) }
      let!(:answer) { create(:answer, :with_file, question: question, user: question.user) }
      let(:file_id) { answer.files[0].id }
      before { login(invalid_user) }

      it 'will not delete a file' do
        expect { delete :destroy, params: { id: file_id, format: :js } }.to_not change(answer.files, :count)
      end

      it 'redirect to root_path' do
        delete :destroy, params: { id: file_id, format: :js }
        expect(response).to have_http_status 403
      end
    end

    context 'with valid user for question' do
      let!(:question_with_file) { create(:question, :with_file) }
      let(:user) { question_with_file.user }
      let(:file_id) { question_with_file.files[0].id }
      before { login(user) }

      it 'deletes a file' do
        expect { delete :destroy, params: { id: file_id, format: :js } }.to change(question_with_file.files, :count).by(-1)
      end

      it 'render destroy template' do
        delete :destroy, params: { id: file_id, format: :js }
        expect(response).to render_template :destroy
      end
    end

    context 'with invalid user for question' do
      let(:invalid_user) { create(:user) }
      let!(:question_with_file) { create(:question, :with_file) }
      let(:file_id) { question_with_file.files[0].id }
      before { login(invalid_user) }

      it 'will not delete a file' do
        expect { delete :destroy, params: { id: file_id, format: :js } }.to_not change(question_with_file.files, :count)
      end

      it 'redirect to root_path' do
        delete :destroy, params: { id: file_id, format: :js }
        expect(response).to have_http_status 403
      end
    end
  end
end