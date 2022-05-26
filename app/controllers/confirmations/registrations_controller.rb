# frozen_string_literal: true

class Confirmations::RegistrationsController < Devise::RegistrationsController
  def create
    build_resource(sign_up_params)
    resource.skip_confirmation!
    resource.confirm

    if resource.save
      set_flash_message! :notice, :signed_up
      sign_up(resource_name, resource)
      respond_with resource, location: after_sign_up_path_for(resource)
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end
end
