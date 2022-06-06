require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) {{"ACCEPT" => 'application/json'}}

  describe 'GET /api/v1/questions/:question_id/answers' do
    let(:me) { create(:user) }
    let(:question) { create(:question) }
    let!(:answers) { create_list(:answer, 5, question: question) }
    let(:answer) { answers.first }
    let(:answer_response) { json['answers'].first }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'should return success status' do
        expect(response).to be_successful
      end

      it 'should return list of answers' do
        expect(json['answers'].map { |a| a['id'] }).to match_array answers.map(&:id)
      end

      it 'should contain public fields' do
        %w[id body user_id question_id created_at updated_at].each do |attr|
          expect(answer_response[attr]).to eq answer.send(attr).as_json
        end
      end
    end
  end

  describe 'GET /api/v1/answers/:id' do
    let(:question) { create(:question) }
    let(:answer) { create(:answer) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id)}

      before { get api_path, params: { access_token: access_token.token }, headers: headers}

      it 'should be successfull' do
        expect(response).to be_successful
      end

      it 'should return all public fields' do
        %w[id body user_id question_id created_at updated_at].each do |attr|
          expect(json['answer'][attr]).to eq answer.send(attr).as_json
        end
      end

      it 'should have keys' do
        %w[links comments files_url].each do |key|
          expect(json['answer']).to have_key key
        end
      end
    end
  end

  describe 'POST /api/v1/questions/:question_id/answers' do
    let(:question) { create(:question) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      context 'when good params' do
        let(:good_answer_params) { attributes_for(:answer) }
        before { post api_path, params: { access_token: access_token.token, answer: good_answer_params }, headers: headers }

        it 'should return status 201' do
          expect(response.status).to eq 201
        end

        it 'should return created answer' do
          %w[id body user_id question_id files_url created_at updated_at].each do |key|
            expect(json['answer']).to have_key(key)
          end
        end
      end

      context 'when bad params' do
        let(:bad_answer_params) { attributes_for(:answer, :invalid) }
        before { post api_path, params: { access_token: access_token.token, answer: bad_answer_params }, headers: headers }

        it 'should return status 422' do
          expect(response.status).to eq 422
        end

        it 'should return created answer' do
          expect(json).to have_key('errors')
        end
      end
    end
  end

  describe 'PUT /api/v1/answers/:id' do
    let(:question) { create(:question) }
    let(:answer) { create(:answer, question: question) }
    let(:me) { answer.user }
    let(:access_token) { create(:access_token, resource_owner_id: me.id) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :put }
    end

    context 'authorized' do
      context 'update with good params' do
        before { put api_path, params: { access_token: access_token.token, answer: { body: "My new body" } }, headers: headers }

        it 'should be successfully' do
          expect(response).to be_successful
        end

        it 'should return updated answer' do
          expect(json['answer']['body']).to eq "My new body"
        end
      end

      context 'update with bad params' do
        before { put api_path, params: { access_token: access_token.token, answer: { body: "" } }, headers: headers }

        it 'should not be successfully' do
          expect(response).to_not be_successful
        end

        it 'should return errors' do
          expect(json).to have_key('errors')
        end
      end
    end
  end

  describe 'DELETE /api/v1/answers/:id' do
    let(:question) { create(:question) }
    let(:answer) { create(:answer, question: question) }
    let(:me) { answer.user }
    let(:access_token) { create(:access_token, resource_owner_id: me.id) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
    end

    it_behaves_like 'API Deletable' do
      let(:record) { 'Answer' }
    end
  end
end