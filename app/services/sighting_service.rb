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
      sighting = current_user.sightings.create(sighting_attributes)
      add_question_to_sighting(sighting)

      result[:data][:sighting] = sighting
    else
      result[:error] = :invalid_sighting_data
    end

    result
  end

  def destroy
    if current_user.sightings.where(id: params[:id]).exists?
      result[:data][:sighting] = Sighting.destroy(params[:id])
    else
      result[:error] = :forbidden_request
    end

    result
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

  def add_question_to_sighting(sighting)
    response = question_provider.fetch_question

    if response[:error].blank?
      sighting.update(question: response[:question])
    else
      Rails.logger.error { "OpentDB: Failed to fetch question. Error Code: #{response[:error]}" }
    end
  rescue Faraday::Error::TimeoutError
    # TODO: Schedule background job to execute in one hour from current time
  end

  def question_provider
    @question_provider ||= ExternalIntegrations::Opentdb.new
  end
end
