class FlowersController < ApplicationController
  def index
    result = flower_service.list_flowers

    if result[:error].present?
      render_error result[:error]
    else
      paginate json: result[:data][:flowers]
    end
  end

  private

  def permitted_params
    params.permit(%i[])
  end

  def flower_service
    @flower_service ||= FlowerService.new(permitted_params)
  end
end
