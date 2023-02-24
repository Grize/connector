class ApplicationController < ActionController::Base
  protect_from_forgery

  private

  def request_params
    Services::JWT::Parser.new(request.headers['Authorization'])
  end
end
