class ApplicationController < ActionController::Base
  include Pundit::Authorization

  before_action :authenticate_user!
  before_action :set_gon_variables!

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def set_gon_variables!
    gon.user_id = current_user&.id
  end

  def user_not_authorized
    redirect_to root_path, alert: "You can't do this."
  end
end
