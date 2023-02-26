class ApplicationController < ActionController::Base
  protect_from_forgery

  def set_current_user
    return unless request.headers['Access-Token']
    @current_user ||= Token.find_by(token: request.headers['Access-Token']).user
  end
end
