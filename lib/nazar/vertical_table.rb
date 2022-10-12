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
      table.render_with(VerticalBorder, options) do |renderer|
        renderer.border.style = :green if Nazar.config.colors.enabled
        renderer.border.separator = separators_around_each_item
      end
    end

    private_constant :VerticalBorder

    private

    def table
      @table ||= TTY::Table.new(rows: cells)
    end

    def options
      {
        multiline: true,
        resize: resize,
        column_widths: column_widths,
        width: max_width
      }
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

    def column_widths
      [headers_width, values_width]
    end

    def max_width
      Nazar.config.table.max_width || default_width
    end

    def default_width
      Nazar.config.table.resize ? TTY::Screen.width : natural_width + padding
    end

    def natural_width
      content_size = headers_width + content_width

      [content_size, TTY::Screen.width].min
    end

    def content_width
      cells.flatten.map(&:size).max
    end

    def headers_width
      [headers.map(&:size).max + 1, Nazar.config.table.min_width].compact.min
    end

    def values_width
      if Nazar.config.table.resize
        TTY::Screen.width - headers_width
      else
        [content_width, TTY::Screen.width - headers_width].min
      end
    end

    def padding
      3
    end
  end
end
