# frozen_string_literal: true

module Nazar
  module Formatter
    module ActiveRecordInterface
      attr_reader :collection, :klass, :attributes

      def valid?
        attributes && klass
      end

      def headers
        HeadersFormatter.new(attributes.keys).format
      end

      def cells
        @cells ||= collection.map do |item|
          item.attributes.map do |column, value|
            CellFormatter.new(value, type: klass.type_for_attribute(column).type).format
          end
        end
      end
    end
  end
end
