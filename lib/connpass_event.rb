# frozen_string_literal: true

require 'faraday'
require_relative 'connpass_event/version'

# rubocop:disable Style/AsciiComments

# connpass API - イベントサーチAPI用モジュール
# https://connpass.com/about/api/
module ConnpassEvent
  class ConnpassEventApiError < StandardError; end

  ENDPOINT = 'https://connpass.com/api/v1'

  # API Client
  class Client
    def initialize
      @connection = Faraday.new(url: ENDPOINT)
    end

    # イベントサーチAPI
    # GET /event/
    # @params params [Hash] リクエストパラメータ
    # @return [Hash] レスポンスボディ
    def events(params = {})
      response = @connection.get('event/') do |request|
        request.params = params
      end

      raise ConnpassEventApiError, "Error is occurred. HTTP STATUS: #{response.status}" unless response.status == 200

      JSON.parse(response.body, symbolize_names: true)
    end
  end

  # connpass API - クエリパラメータ用クラス
  class Request
    PARAMETERS = %i[event_id keyword keyword_or ym ymd nickname owner_nickname series_id start order count
                    format].freeze

    def self.params(**options)
      options.each_with_object({}) do |(key, value), result|
        unless PARAMETERS.include?(key)
          puts "except key: #{key}"
          next
        end
        result[key] = value
      end
    end
  end
end
# rubocop:enable Style/AsciiComments
