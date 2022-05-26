class FindForOauth
  attr_reader :auth

  def initialize(auth)
    @auth = auth
  end

  def call
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization

    email = auth.info[:email]
    user = User.where(email: email).first
    if user
      user.create_authorization(auth)
    else
      password = Devise.friendly_token[0, 20]
      if email.present?
        user = User.new(email: email, password: password, password_confirmation: password)
        user.skip_confirmation!
        user.save
        user.confirm
      else
        user = User.new(password: password, password_confirmation: password)
        user.save(validate: false)
      end
      user.create_authorization(auth)
    end

    user
  end
end