# frozen_string_literal: true

module Nazar
  class View
    extend Forwardable

    def_delegators :formatter, :headers, :cells, :summary

    def initialize(data, use_generic_formatter: false)
      @data = data
      @use_generic_formatter = use_generic_formatter
    end

    def render
      return unless supported_data?

      table.tap do
        add_summary if summary
      end
    end

    def supported_data?
      !!formatter_klass && formatter.valid?
    end

    private

    attr_reader :data, :use_generic_formatter

    def formatters
      @formatters ||= Nazar.formatters.tap do |formatters|
        formatters << Nazar::Formatter::Generic if use_generic_formatter
      end
    end

    def formatter_klass
      @formatter_klass ||= formatters.find { |klass| klass.valid?(data) }
    end

    def formatter
      @formatter ||= formatter_klass.new(data)
    end

    def add_summary
      table.add_separator
      table.add_row [pastel.bold('Total'), { value: summary, colspan: headers.size - 1 }]
    end

    def table
      @table ||= Terminal::Table.new(
        headings: headers,
        rows: cells,
        style: { border: :unicode_thick_edge }
      )
    end

    def pastel
      @pastel ||= Pastel.new(enabled: Nazar.config.colors.enabled)
    end
  end
end
