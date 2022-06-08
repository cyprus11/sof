require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) {{"ACCEPT" => 'application/json'}}

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) {create(:access_token)}
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }
      let!(:answers) { create_list(:answer, 3, question: question) }

      before {get api_path, params: {access_token: access_token.token}, headers: headers}

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of questions' do
        expect(json['questions'].size).to eq 2
      end

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      it 'contains user object' do
        expect(question_response['user']['id']).to eq question.user.id
      end

      it 'contains short title' do
        expect(question_response['short_title']).to eq question.title.truncate(7)
      end

      describe 'answers' do
        let(:answer) { answers.first }
        let(:answer_response) { question_response['answers'].first }

        it 'returns list of answers' do
          expect(question_response['answers'].size).to eq 3
        end

        it 'returns all public fields' do
          %w[id body user_id question_id created_at updated_at].each do |attr|
            expect(answer_response[attr]).to eq answer.send(attr).as_json
          end
        end
      end
    end
  end

  describe "POST /api/v1/questions" do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      describe 'with good params' do
        let(:good_question_params) { attributes_for(:question) }
        before { post api_path, params: { access_token: access_token.token, question: good_question_params }, headers: headers }

        it 'should return 201 status' do
          expect(response.status).to eq 201
        end

        it 'creates a new question' do
          expect(me.questions.size).to eq 1
        end

        it 'returns fields that was sended in parameters' do
          %w[title body].each do |attr|
            expect(json['question'][attr]).to eq good_question_params[attr.to_sym]
          end
        end

        it 'has key for associations' do
          %w[files_url answers user comments].each do |key|
            expect(json['question']).to have_key(key)
          end
        end
      end

      describe 'with bad params' do
        let(:bad_question_params) { attributes_for(:question, :invalid) }
        before { post api_path, params: { access_token: access_token.token, question: bad_question_params }, headers: headers }

        it 'should return status 422' do
          expect(response.status).to eq 422
        end

        it 'should contain key errors' do
          expect(json).to have_key('errors')
        end
      end
    end
  end

  describe 'PUT /api/v1/questions/:id' do
    let(:me) { create(:user) }
    let(:question) { create(:question, user: me) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :put }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      describe 'with valid params' do
        before { put api_path, params: { access_token: access_token.token, question: { title: 'new title', body: 'new body' }, headers: headers }  }

        it 'should return status 201' do
          expect(response.status).to eq 201
        end

        it 'should return updated question' do
          expect(json['question']['title']).to eq 'new title'
          expect(json['question']['body']).to eq 'new body'
        end
      end

      describe 'with wrong params' do
        before { patch api_path, params: { access_token: access_token.token, question: { title: '', body: '' }, headers: headers }  }

        it 'should return status 422' do
          expect(response.status).to eq 422
        end

        it 'should return errors' do
          expect(json).to have_key 'errors'
        end
      end
    end
  end

  describe 'DELETE /api/v1/questions/:id' do
    let(:me) { create(:user) }
    let(:access_token) { create(:access_token, resource_owner_id: me.id) }
    let(:question) { create(:question, user: me) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
    end

    it_behaves_like 'API Deletable' do
      let(:record) { 'Question' }
    end
  end
end