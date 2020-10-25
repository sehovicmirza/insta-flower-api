module Authenticable
  extend ActiveSupport::Concern

  AUTH_HEADER = 'Authorization'.freeze
  TOKEN_DELIMITER = ' '.freeze
  USER_ID_KEY = 'user_id'.freeze

  attr_reader :current_user, :payload

  included do
    before_action :authenticate
  end

  private

  def authenticate
    if token
      @payload = JwtService.decode(token)
      @current_user = User.find_by(id: user_id)
    end

    render_error :unauthenticated_request unless current_user
  rescue JWT::DecodeError
    render_error :unauthenticated_request
  end

  def token
    @token ||= request.headers[AUTH_HEADER].try(:split, TOKEN_DELIMITER)&.second
  end

  def user_id
    payload.first.try(:[], USER_ID_KEY)
  end
end
