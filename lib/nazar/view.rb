# frozen_string_literal: true

module Nazar
  class View
    extend Forwardable

    def_delegators :formatter, :headers, :cells, :summary

    def initialize(data)
      @data = data
    end

    def render
      add_summary if summary

      table
    end

    private

    attr_reader :data

    def formatter
      Formatter::CSVTable.new(data)
    end

    def add_summary
      table.add_separator
      table.add_row [Pastel.new.bold('Total'), { value: summary, colspan: headers.size - 1 }]
    end

    def table
      @table ||= Terminal::Table.new(
        headings: headers,
        rows: cells,
        style: { border: :unicode_thick_edge }
      )
    end
  end
end
