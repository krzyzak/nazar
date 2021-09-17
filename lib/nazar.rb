# frozen_string_literal: true

require 'active_record'
require 'csv'
require 'dry-configurable'
require 'terminal-table'
require 'pastel'
require 'tty-pager'

require 'nazar/version'
require 'nazar/cell_formatter'
require 'nazar/headers_formatter'
require 'nazar/renderer'
require 'nazar/formatter'
require 'nazar/formatter/csv_table'
require 'nazar/formatter/active_record_collection'
require 'nazar/view'

module Nazar
  extend Dry::Configurable

  setting :formatter do
    setting :nil, default: '∅'
    setting :boolean, default: ['✓', '✗']
  end

  def self.enable!
    if defined?(IRB)
      ::IRB::Irb.class_eval do
        alias_method :__original_output_value__, :output_value
        def output_value(omit = false)
          ::Nazar::Renderer.new(@context.last_value).render || __original_output_value__(omit)
        end
      end
    end
  end

  def self.disable!
    ::IRB::Irb.send(:alias_method, :output_value, :__original_output_value__)
  end
end
