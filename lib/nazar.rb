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
require 'nazar/formatter/generic'
require 'nazar/view'

module Nazar # rubocop:disable Metrics/ModuleLength
  extend Dry::Configurable

  setting :formatter do
    setting :nil, default: '∅'
    setting :boolean, default: ['✓', '✗']
  end

  setting :colors do
    setting :enabled, default: ENV.fetch('ENABLE_TTY_COLORS') { TTY::Color.color? ? 'true' : 'false' } == 'true'
  end

  setting :enable_shorthand_method, default: true

  class << self
    def formatters
      @formatters ||= Set.new
    end

    def enable!(extensions: [:active_record, :csv])
      return if @enabled

      load_extensions!(extensions)
      enable_repl!

      enable_shorthand_method! if Nazar.config.enable_shorthand_method

      @enabled = true
    end

    def load!(extensions: [:active_record, :csv])
      load_extensions!(extensions)
      enable_shorthand_method! if Nazar.config.enable_shorthand_method

      true
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

    def load_sequel!
      require 'sequel'

      register_formatter!('SequelCollection', 'nazar/formatter/sequel_collection')
      register_formatter!('SequelItem', 'nazar/formatter/sequel_item')
    end

    def register_formatter!(klass_name, path)
      require path

      formatters << Nazar::Formatter.const_get(klass_name)
    end

    def pry_proc
      return unless defined?(Pry)

      proc do |output, value, instance|
        renderer = Nazar::Renderer.new(value)
        renderer.valid? ? renderer.render : @__original_pry_print.call(output, value, instance)
      end
    end

    def disable!
      disable_shorthand_method! if @defined_shorthand_method

      return unless @enabled

      disable_for_irb! if defined?(IRB)
      disable_for_pry! if defined?(Pry)

      @enabled = false
    end

    private

    def load_extensions!(extensions)
      load_active_record! if extensions.include?(:active_record)
      load_csv! if extensions.include?(:csv)
      load_sequel! if extensions.include?(:sequel)
    end

    def enable_repl!
      enable_for_irb! if defined?(IRB)
      enable_for_pry! if defined?(Pry)
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
      @__original_pry_print ||= Pry.config.print

      if Pry.toplevel_binding.local_variable_defined?(:pry_instance)
        Pry.toplevel_binding.eval('pry_instance.config.print = Nazar.pry_proc', __FILE__, __LINE__)
      else
        Pry.config.print = Nazar.pry_proc
      end
    end

    def enable_shorthand_method!
      if Object.respond_to?(:__)
        return warn Pastel.new.red("Already defined Object#__() method, Nazar won't redefine it.")
      end

      @defined_shorthand_method = true

      Object.class_eval do
        def __(item)
          Nazar::Renderer.new(item, use_generic_formatter: true).render
        end
      end
    end

    def disable_shorthand_method!
      @defined_shorthand_method = nil

      Object.class_eval do
        undef_method :__
      end
    end

    def disable_for_irb!
      ::IRB::Irb.send(:alias_method, :output_value, :__original_output_value__)
    end

    def disable_for_pry!
      Pry.toplevel_binding.eval(
        'pry_instance.config.print = Nazar.instance_variable_get(:@__original_pry_print)',
        __FILE__,
        __LINE__
      )
    end
  end
end
