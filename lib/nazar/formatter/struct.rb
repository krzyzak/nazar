# frozen_string_literal: true

module Nazar
  module Formatter
    class Struct
      def initialize(item)
        @collection = item.is_a?(Array) ? item : [item]
        @attributes = @collection.first.to_h.keys
      end

      def self.valid?(data)
        valid_struct?(data) || (data.is_a?(Array) && data.all? { valid_struct?(_1) })
      end

      def self.valid_struct?(data)
        data.is_a?(::Struct) || data.is_a?(::OpenStruct)
      end

      def valid?
        @attributes.any?
      end

      def headers
        HeadersFormatter.new(@attributes).format
      end

      def cells
        @cells ||= @collection.map do |item|
          item.to_h.values.map do |value|
            CellFormatter.new(value, type: nil).format
          end
        end
      end

      def summary
        false
      end
    end
  end
end
