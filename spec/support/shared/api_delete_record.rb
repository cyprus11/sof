shared_examples_for 'API Deletable' do
  context 'authorized' do
    it 'should be successfully' do
      do_request(:delete, api_path, params: { access_token: access_token.token }, headers: headers)
      expect(response).to be_successful
    end

    it 'should return a message that record was deleted' do
      do_request(:delete, api_path, params: { access_token: access_token.token }, headers: headers)
      expect(json['message']).to eq "#{record} was deleted"
    end
  end
end