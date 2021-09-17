# frozen_string_literal: true

module Nazar
  module Formatter
    class ActiveRecordCollection
      attr_reader :collection, :klass

      def initialize(collection)
        @collection = collection
        @klass = collection.first.class
      end

      def headers
        HeadersFormatter.new(collection.first.attributes.keys).format
      end

      def cells
        @cells ||= collection.map do |item|
          item.attributes.map do |column, value|
            CellFormatter.new(value, type: klass.type_for_attribute(column).type).format
          end
        end
      end

      def summary
        collection.size
      end
    end
  end
end
