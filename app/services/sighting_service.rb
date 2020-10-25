class SightingService
  REQUIRED_ATTRIBUTES = %w[flower_id latitude longitude image].freeze

  attr_reader :params, :current_user, :result

  def initialize(params, current_user)
    @params = params
    @current_user = current_user
    @result = { error: nil, data: {} }
  end

  def list_sightings
    if (flower_id = params[:flower_id])
      result[:data][:sightings] = Sighting.for_flower(flower_id)
    else
      result[:error] = :missing_flower_id
    end

    result
  end

  def create
    if valid_params?
      result[:data][:sighting] = current_user.sightings.create(sighting_attributes)
    else
      result[:error] = :invalid_sighting_data
    end

    result
  end

  def destroy
    # TODO
  end

  private

  def valid_params?
    REQUIRED_ATTRIBUTES.all? { |attr| params.keys.include?(attr) }
  end

  def sighting_attributes
    {
      flower_id: params[:flower_id],
      latitude: params[:latitude],
      longitude: params[:longitude],
      image: params[:image]
    }
  end
end
