class OauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    oauth_authenticate('GitHub')
  end

  def vkontakte
    oauth_authenticate('Vkontakte')
  end

  private

  def oauth_authenticate(provider)
    @user = User.find_for_oauth(request.env['omniauth.auth'])

    if @user&.persisted? && @user&.confirmed?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: provider) if is_navigational_format?
    elsif @user&.persisted? && !@user&.confirmed?
      render 'confirmations/confirm_email'
    else
      redirect_to root_path, alert: 'Something went wrong.'
    end
  end
end