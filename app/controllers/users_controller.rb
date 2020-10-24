class UsersController < ApplicationController
  def create
    result = user_service.register

    if result[:error].present?
      render_error result[:error]
    else
      render json: result[:data]
    end
  end

  def login
    result = user_service.login

    if result[:error].present?
      render_error result[:error]
    else
      render json: result[:data]
    end
  end

  private

  def permitted_params
    params.permit(%i[email username password])
  end

  def user_service
    @user_service ||= UserService.new(permitted_params)
  end
end
