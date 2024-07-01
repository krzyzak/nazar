# frozen_string_literal: true

require 'nazar/formatter/active_record_interface'

module Nazar
  module Formatter
    class ActiveRecordCollection
      include ActiveRecordInterface

      def initialize(collection)
        @collection = collection
        @collection.load if @collection.respond_to?(:loaded?) && !@collection.loaded?

        @attributes = collection.first&.attributes
        @klass = collection.first&.class
      end

      def self.valid?(data)
        return false if data.is_a?(Struct) || (defined?(OpenStruct) && data.is_a?(OpenStruct))

        data.is_a?(ActiveRecord::Associations::CollectionProxy) ||
          data.is_a?(ActiveRecord::Relation) ||
          (data.is_a?(Enumerable) && data.first.is_a?(ActiveRecord::Base))
      end

      def summary
        collection.size
      end
    end
  end
end
