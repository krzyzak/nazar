# frozen_string_literal: true

module Nazar
  class View
    extend Forwardable

    def_delegators :formatter, :headers, :summary

    def initialize(data, layout:, use_generic_formatter: false)
      @data = data
      @use_generic_formatter = use_generic_formatter
      @layout = layout
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
        horizontal_cells.map { |row| row.map(&:size).sum }.max
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

    def add_summary
      colspan = horizontal? ? headers.size - 1 : 1

      table.add_separator
      table.add_row [pastel.bold('Total'), { value: summary, colspan: colspan }]
    end

    def table
      @table ||= Terminal::Table.new(
        headings: display_headers,
        rows: display_cells,
        style: { border: :unicode_thick_edge }
      )
    end

    def display_headers
      horizontal? ? formatter.headers : []
    end

    def display_cells
      horizontal? ? horizontal_cells : vertical_cells
    end

    def horizontal_cells
      formatter.cells
    end

    def vertical_cells
      data = horizontal_cells.inject([]) do |output, items|
        items.each.with_index do |item, index|
          output << [headers[index], item]
        end

        output << :separator
      end

      data.pop # remove last separator
      data
    end

    def pastel
      @pastel ||= Pastel.new(enabled: Nazar.config.colors.enabled)
    end
  end
end
