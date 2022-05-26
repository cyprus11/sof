# frozen_string_literal: true

class Confirmations::ConfirmationsController < Devise::ConfirmationsController
  before_action :update_user_email, only: :create

  private

  def update_user_email
    if params.dig(:user, :confirmation_token).present?
      user = User.find_by(confirmation_token: params.dig(:user, :confirmation_token))
      user.update!(email: params.dig(:user, :email))
    end
  end
end
