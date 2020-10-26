class LikesController < ApplicationController
  include Authenticable

  def create
    result = like_service.create

    if result[:error].present?
      render_error result[:error]
    else
      render json: result[:data][:like]
    end
  end

  def destroy
    result = like_service.destroy

    if result[:error].present?
      render_error result[:error]
    else
      head :ok
    end
  end

  private

  def permitted_params
    params.permit(%i[id sighting_id])
  end

  def like_service
    @like_service ||= LikeService.new(permitted_params, current_user)
  end
end
