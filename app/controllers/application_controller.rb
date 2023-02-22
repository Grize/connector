class ApplicationController < ActionController::Base
  protect_from_forgery
  before_action :configure_permitted_parameters

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_in, keys: [:secret])
  end

  def request_params
    Services::JWT::Parser.new(request.headers['Authorization'])
  end
end
