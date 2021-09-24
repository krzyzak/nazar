# frozen_string_literal: true

require 'nazar/formatter/sequel_interface'

module Nazar
  module Formatter
    class SequelItem
      include SequelInterface

      def initialize(item)
        @collection = [item]
        @attributes = item.values
        @klass = item.class
      end

      def self.valid?(data)
        data.is_a?(Sequel::Model)
      end

      def summary
        false
      end
    end
  end
end
