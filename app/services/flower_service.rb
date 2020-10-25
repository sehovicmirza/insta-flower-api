class FlowerService
  attr_reader :params, :result

  def initialize(params)
    @params = params
    @result = { error: nil, data: {} }
  end

  def list_flowers
    result[:data][:flowers] = Flower.all

    result
  end
end
