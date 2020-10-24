class UserService
  attr_reader :params, :result

  def initialize(params)
    @params = params
    @result = { error: nil, data: {} }
  end

  def register
    user = User.create(params)

    if user.valid?
      result[:data][:token] = JwtService.encode({ user_id: user.id })
    else
      result[:error] = :invalid_input_data
    end

    result
  end

  def login
    user = User.find_by(username: params[:username])

    if user&.authenticate(params[:password])
      result[:data][:token] = JwtService.encode({ user_id: user.id })
    else
      result[:error] = :invalid_credentials
    end

    result
  end
end
