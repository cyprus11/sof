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
    respond_to do |format|
      message = "You can't do this."
      format.html { redirect_to root_path, alert: message }
      format.json { render json: { messages: { alert: message } }, status: 403 }
      format.js do
        flash[:alert] = message
        render partial: 'shared/flash_js', status: 403
      end
    end
  end
end
