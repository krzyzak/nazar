# frozen_string_literal: true

module Nazar
  class HeadersFormatter
    def initialize(headers)
      @headers = headers
    end

    def format
      headers.map { |header| pastel.bold(header) }
    end

    private

    attr_reader :headers

    def pastel
      @pastel ||= Pastel.new
    end
  end
end
