# frozen_string_literal: true

module Nazar
  module Formatter
    class Struct
      def initialize(item)
        @collection = Array(item)
        @attributes = item.to_h.keys
        @item = item
      end

      def self.valid?(data)
        data.is_a?(::Struct) || data.is_a?(::OpenStruct)
      end

      def valid?
        true
      end

      def headers
        HeadersFormatter.new(attributes).format
      end

      def cells
        @cells ||= @collection.map do |item|
          item.each_pair do |_, value|
            CellFormatter.new(value, type: nil).format
          end
        end
      end
    end
  end
end
