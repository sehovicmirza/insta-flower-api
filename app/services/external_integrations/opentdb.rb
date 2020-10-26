module ExternalIntegrations
  class Opentdb
    ROOT_KEY = 'results'.freeze

    attr_reader :result

    def initialize
      @result = { error: nil, question: nil }
    end

    def fetch_question
      response = Faraday.get(ENV['OPENTDB_URL'])

      if response.status == 200
        result[:question] = parse_question(response.body)
      else
        result[:error] = :failed_opentdb_fetch
      end

      result
    end

    private

    def parse_question(body)
      JSON.parse(body)[ROOT_KEY].first
    end
  end
end
