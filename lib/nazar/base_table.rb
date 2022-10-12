# frozen_string_literal: true

module Nazar
  class BaseTable
    def initialize(headers, cells)
      @headers = headers
      @cells = cells
    end

    def render
      table.render
    end

    def add_summary(value)
      table << :separator
      table << summary_row(value)
    end

    private

    attr_reader :headers, :cells

    def table
      @table ||= TTY::Table.new(header: headers, rows: cells)
    end

    def resize
      Nazar.config.formatter.resize
    end

    def summary_row(value)
      [pastel.bold('Total'), value]
    end

    def pastel
      @pastel ||= Pastel.new(enabled: Nazar.config.colors.enabled)
    end
  end
end
