module OmniAuthHelpers
  def mock_auth_hash(provider, email = nil)
    email ||= 'test@mail.com'
    OmniAuth.config.mock_auth[provider.downcase.to_sym] = OmniAuth::AuthHash.new({
      'provider' => provider.downcase,
      'uid' => '123456',
      'info' => {
        'email' => email
      },
      'credentials' => {
        "token" => "mock_credentials_token",
        "secret" => "mock_credentials_secret"
      }
    })
  end
end