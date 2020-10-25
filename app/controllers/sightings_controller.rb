class SightingsController < ApplicationController
  include Authenticable

  skip_before_action :authenticate, only: %i[index]

  def index
    result = sighting_service.list_sightings

    if result[:error].present?
      render_error result[:error]
    else
      paginate json: result[:data][:sightings]
    end
  end

  def create
    result = sighting_service.create

    if result[:error].present?
      render_error result[:error]
    else
      render json: result[:data][:sighting]
    end
  end

  def destroy
    # TODO
  end

  private

  def permitted_params
    params.permit(%i[flower_id sighting_id latitude longitude image])
  end

  def sighting_service
    @sighting_service ||= SightingService.new(permitted_params, current_user)
  end
end
