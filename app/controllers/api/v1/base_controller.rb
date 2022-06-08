class Api::V1::BaseController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token
  before_action :doorkeeper_authorize!

  private

  def current_resource_owner
    @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end

  def render_error_json(resource)
    render json: { errors: resource.errors }, status: 422
  end

  alias_method :current_user, :current_resource_owner
end