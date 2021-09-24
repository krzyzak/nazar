# frozen_string_literal: true

require 'nazar/formatter/sequel_interface'

module Nazar
  module Formatter
    class SequelCollection
      include SequelInterface

      def initialize(collection)
        @collection = collection
        @attributes = collection.first&.values
      end

      def self.valid?(data)
        data.is_a?(Array) && data.first.is_a?(Sequel::Model)
      end

      def summary
        collection.size
      end
    end
  end
end
