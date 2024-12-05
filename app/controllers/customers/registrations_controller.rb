# frozen_string_literal: true

class Customers::RegistrationsController < Devise::RegistrationsController
  def create
    Rails.logger.debug "Request format: #{request.format}"

    build_resource(sign_up_params)

    if resource.save
      sign_up(resource_name, resource)
      respond_to do |format|
        format.html { redirect_to root_path, notice: "Account successfully created!" }
      end
    else
      clean_up_passwords(resource)
      set_minimum_password_length
      respond_to do |format|
        format.html { render :new }
      end
    end
  rescue ActionController::UnknownFormat
    redirect_to new_customer_registration_path, alert: "Unsupported format"
  end
end











# before_action :configure_sign_up_params, only: [:create]
# before_action :configure_account_update_params, only: [:update]

# GET /resource/sign_up
# def new
#   super
# end

# POST /resource
# def create
#   super
# end

# GET /resource/edit
# def edit
#   super
# end

# PUT /resource
# def update
#   super
# end

# DELETE /resource
# def destroy
#   super
# end

# GET /resource/cancel
# Forces the session data which is usually expired after sign
# in to be expired now. This is useful if the user wants to
# cancel oauth signing in/up in the middle of the process,
# removing all OAuth session data.
# def cancel
#   super
# end

# protected

# If you have extra params to permit, append them to the sanitizer.
# def configure_sign_up_params
#   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
# end

# If you have extra params to permit, append them to the sanitizer.
# def configure_account_update_params
#   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
# end

# The path used after sign up.
# def after_sign_up_path_for(resource)
#   super(resource)
# end

# The path used after sign up for inactive accounts.
# def after_inactive_sign_up_path_for(resource)
#   super(resource)
# end
