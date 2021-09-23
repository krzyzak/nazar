# frozen_string_literal: true

module Nazar
  module Formatter
    class CSVTable
      attr_reader :collection

      def initialize(collection)
        @collection = collection
      end

      def valid?
        !!collection && !collection.empty?
      end

      def headers
        HeadersFormatter.new(collection.headers).format
      end

      def cells
        @cells ||= collection.map do |item|
          item.fields.map do |value|
            CellFormatter.new(value, type: detect_type(value)).format
          end
        end
      end

      def summary
        collection.size
      end

      private

      BOOLEAN_VALUES = TRUTHY_VALUES + FALSY_VALUES

      def detect_type(value)
        case value
        when ->(val) { BOOLEAN_VALUES.include?(val.to_s.downcase) }
          :boolean
        when Numeric
          :numeric
        else
          :string
        end
      end
    end
  end
end
