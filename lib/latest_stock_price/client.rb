require "net/http"
require "json"
require "uri"

module LatestStockPrice
  class Client
    BASE_URL = "https://latest-stock-price.p.rapidapi.com".freeze
    RAPIDAPI_HOST = "latest-stock-price.p.rapidapi.com".freeze

    def initialize(api_key)
      @api_key = api_key
    end

    # Method to get price of a single stock
    # def price(symbol)
    #   endpoint = "/price"
    #   params = { Indices: symbol }

    #   response = get_request(endpoint, params)
    #   parse_response(response)
    # end

    # Method to get prices of multiple stocks
    # def prices(symbols)
    #   endpoint = "/prices"
    #   params = { Indices: symbols.join(",") }

    #   response = get_request(endpoint, params)
    #   parse_response(response)
    # end

    # Method to get price of all stocks
    def price_all
      endpoint = "/any"

      response = get_request(endpoint)
      parse_response(response)
    end

    private

    def get_request(endpoint, params = {})
      url = URI(BASE_URL + endpoint)
      url.query = URI.encode_www_form(params) unless params.empty?

      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true

      request = Net::HTTP::Get.new(url)
      request["x-rapidapi-host"] = RAPIDAPI_HOST
      request["x-rapidapi-key"] = @api_key

      http.request(request)
    end

    def parse_response(response)
      if response.is_a?(Net::HTTPSuccess)
        JSON.parse(response.body)
      else
        raise StandardError, "Error: #{response.message}"
      end
    end
  end
end