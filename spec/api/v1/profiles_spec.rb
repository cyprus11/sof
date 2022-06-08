require 'rails_helper'

describe 'Profiles API', type: :request do
  let(:headers) { {
    "CONTENT_TYPE" => "application/json",
    "ACCEPT" => "json"
  } }

  it_behaves_like 'API Authorizable' do
    let(:method) { :get }
    let(:api_path) { '/api/v1/profiles/me' }
  end

  describe "GET /api/v1/profiles/me" do
    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles/me', params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %w[id email admin created_at updated_at].each do |attr|
          expect(json['user'][attr]).to eq me.send(attr).as_json
        end
      end

      it 'does not return private fields' do
        %w[password encrypted_password].each do |attr|
          expect(json).to_not have_key(attr)
        end
      end
    end
  end

  describe "GET /api/v1/profiles" do
    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      let!(:other_users) { create_list(:user, 5) }

      before { get '/api/v1/profiles', params: { access_token: access_token.token }, headers: headers }

      it "doesn't return authenticated user" do
        expect(json['users'].map{ |arr| arr['id'] }).not_to include(me.id)
      end

      it "should return other users" do
        other_users.map(&:id).each do |id|
          expect(json['users'].map{ |arr| arr['id'] }).to include(id)
        end
      end

      it 'returns 200 status' do
        expect(response).to be_successful
      end
    end
  end
end