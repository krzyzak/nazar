# frozen_string_literal: true

module Nazar
  module Formatter
    class Generic
      attr_reader :collection

      def initialize(collection)
        @collection = Array(collection)
        @item = collection.first
      end

      def headers
        HeadersFormatter.new(raw_headers).format
      end

      def cells
        @cells ||= collection.map do |item|
          item.values.map do |value|
            CellFormatter.new(value).format
          end
        end
      end

      def summary
        collection.size
      end

      def self.valid?(data)
        item = data.first
        compatible = item.respond_to?(:keys) && item.respond_to?(:values)

        data.is_a?(Enumerable) && (item.is_a?(Struct) || compatible)
      end

      def valid?
        !!item && !raw_headers.empty?
      end

      private

      attr_reader :item

      def raw_headers
        @raw_headers ||= if item.is_a?(Struct)
          item.members
        elsif item.respond_to?(:keys)
          item.keys
        else
          []
        end
      end
    end
  end
end
