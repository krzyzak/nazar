# frozen_string_literal: true

require 'nazar/formatter/active_record_interface'

module Nazar
  module Formatter
    class ActiveRecordItem
      include ActiveRecordInterface

      def initialize(item)
        @collection = [item]
        @attributes = item.attributes
        @klass = item.class
      end

      def self.valid?(data)
        data.is_a?(ActiveRecord::Base)
      end

      def summary
        false
      end
    end
  end
end
