class LikeService
  attr_reader :params, :current_user, :result

  def initialize(params, current_user)
    @params = params
    @current_user = current_user
    @result = { error: nil, data: {} }
  end

  def create
    if params[:sighting_id].present?
      result[:data][:like] = current_user.likes.create(sighting_id: params[:sighting_id])
    else
      result[:error] = :invalid_like_data
    end

    result
  end

  def destroy
    if current_user.likes.where(id: params[:id]).exists?
      result[:data][:like] = Like.destroy(params[:id])
    else
      result[:error] = :forbidden_request
    end

    result
  end
end
