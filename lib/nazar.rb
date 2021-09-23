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
    def formatters
      @formatters ||= Set.new
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
      require 'csv'

      register_formatter!('CSVTable', 'nazar/formatter/csv_table')
    end

    def load_active_record!
      require 'active_record'

      register_formatter!('ActiveRecordCollection', 'nazar/formatter/active_record_collection')
      register_formatter!('ActiveRecordItem', 'nazar/formatter/active_record_item')
    end

    def register_formatter!(klass_name, path)
      require path

      formatters << Nazar::Formatter.const_get(klass_name)
    end

    def enable_for_irb!
      ::IRB::Irb.class_eval do
        alias_method :__original_output_value__, :output_value
        def output_value(omit = false) # rubocop:disable Style/OptionalBooleanParameter
          renderer = Nazar::Renderer.new(@context.last_value)
          renderer.valid? ? renderer.render : __original_output_value__(omit)
        end
      end
    end

    def enable_for_pry!
      @__original_pry_print = Pry.config.print
      Pry.config.print = proc do |output, value, instance|
        renderer = Nazar::Renderer.new(value)
        renderer.valid? ? renderer.render : @__original_pry_print.call(output, value, instance)
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
