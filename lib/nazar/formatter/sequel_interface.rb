# frozen_string_literal: true

module Nazar
  module Formatter
    module SequelInterface
      attr_reader :collection, :klass, :attributes

      def valid?
        !!attributes
      end

      def headers
        HeadersFormatter.new(attributes.keys).format
      end

      def cells
        @cells ||= begin
          schema = collection.first.db_schema

          collection.map do |item|
            item.values.map do |column, value|
              CellFormatter.new(value, type: schema.dig(column, :type)).format
            end
          end
        end
      end

      def summary
        collection.size
      end
    end
  end
end
