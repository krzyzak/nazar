# frozen_string_literal: true

module Nazar
  class View
    extend Forwardable

    def_delegators :formatter, :headers, :cells, :summary

    def initialize(data, layout:, use_generic_formatter: false)
      @data = data
      @use_generic_formatter = use_generic_formatter
      @layout = layout
    end

    def render
      return unless supported_data?

      table.add_summary(summary) if summary

      table.render
    end

    def supported_data?
      !!formatter_klass && formatter.valid?
    end

    def layout
      case @layout
      when :auto
        determine_layout
      when :vertical
        :vertical
      when :horizontal
        :horizontal
      else
        raise ArgumentError, "Unknown layout: #{Nazar.config.formatter.layout}"
      end
    end

    def horizontal?
      layout == :horizontal
    end

    private

    attr_reader :data, :use_generic_formatter

    def determine_layout
      table_width > TTY::Screen.width ? :vertical : :horizontal
    end

    def table_width
      [
        headers.map(&:size).sum,
        *cells.map { |row| row.map(&:size).sum }
      ].max
    end

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

    def table
      @table ||= horizontal? ? HorizontalTable.new(headers, cells) : VerticalTable.new(headers, cells)
    end
  end
end
