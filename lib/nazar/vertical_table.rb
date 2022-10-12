# frozen_string_literal: true

module Nazar
  class VerticalTable < BaseTable
    class VerticalBorder < TTY::Table::Border
      def_border do
        top '─'
        top_mid '─'
        top_left '─'
        top_right '─'
        bottom '─'
        bottom_mid '─'
        bottom_left '─'
        bottom_right '─'
        mid '─'
        mid_mid '─'
        mid_left '─'
        mid_right '─'
        left ''
        center ''
        right ''
      end
    end

    def render
      table.render_with(VerticalBorder, multiline: true, resize: false) do |renderer|
        renderer.border.style = :green
        renderer.border.separator = separators_around_each_item
      end
    end

    private_constant :VerticalBorder

    private

    def table
      @table ||= TTY::Table.new(rows: cells)
    end

    def cells
      @cells.flat_map do |cell|
        cell.map.with_index do |item, index|
          ["#{headers[index]} ", item]
        end
      end
    end

    def separators_around_each_item
      (0...cells.size).select do |i|
        (i % headers.size).zero? || ((i + 1) % headers.size).zero?
      end
    end
  end
end
