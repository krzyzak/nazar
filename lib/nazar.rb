# frozen_string_literal: true

require 'dry-configurable'
require 'terminal-table'
require 'pastel'
require 'tty-pager'

require 'nazar/version'
require 'nazar/cell_formatter'
require 'nazar/headers_formatter'
require 'nazar/renderer'
require 'nazar/formatter'
require 'nazar/view'

module Nazar
  extend Dry::Configurable

  setting :formatter do
    setting :nil, default: '∅'
    setting :boolean, default: ['✓', '✗']
  end

  setting :colors do
    setting :enabled, default: ENV.fetch('ENABLE_TTY_COLORS') { TTY::Color.color? ? 'true' : 'false' } == 'true'
  end

  class << self
    def extensions
      @extensions ||= Set.new
    end

    def enable!(extensions: [:active_record, :csv])
      return if @enabled

      load_active_record! if extensions.include?(:active_record)
      load_csv! if extensions.include?(:csv)

      enable_for_irb! if defined?(IRB)
      enable_for_pry! if defined?(Pry)

      @enabled = true
    end

    def load_csv!
      extensions << :csv

      require 'csv'
      load 'nazar/formatter/csv_table.rb'
    end

    def load_active_record!
      extensions << :active_record

      require 'active_record'
      load 'nazar/formatter/active_record_collection.rb'
      load 'nazar/formatter/active_record_item.rb'
    end

    def enable_for_irb!
      ::IRB::Irb.class_eval do
        alias_method :__original_output_value__, :output_value
        def output_value(omit = false) # rubocop:disable Style/OptionalBooleanParameter
          ::Nazar::Renderer.new(@context.last_value).render || __original_output_value__(omit)
        end
      end
    end

    def enable_for_pry!
      @__original_pry_print = Pry.config.print
      Pry.config.print = proc do |output, value, instance|
        output.puts Nazar::Renderer.new(value).render || @__original_pry_print.call(output, value, instance)
      end
    end

    def disable!
      return unless @enabled

      disable_for_irb! if defined?(IRB)

      @enabled = false
    end

    def disable_for_irb!
      ::IRB::Irb.send(:alias_method, :output_value, :__original_output_value__)
    end

    def disable_for_pry!
      nil
    end
  end
end
