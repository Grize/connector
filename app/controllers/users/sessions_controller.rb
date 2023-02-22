class Users::SessionsController < Devise::SessionsController
  def create
    super do |resources|
      Services::Token::Create.new(resources, request.params).call
      render status: 200
    end
  end
end
