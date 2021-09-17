# frozen_string_literal: true

require 'nazar/formatter/active_record_interface'

module Nazar
  module Formatter
    class ActiveRecordCollection
      include ActiveRecordInterface

      def initialize(collection)
        @collection = collection
        @attributes = collection.first.attributes
        @klass = collection.first.class
      end

      def summary
        collection.size
      end
    end
  end
end
