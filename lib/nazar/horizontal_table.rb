# frozen_string_literal: true

module Nazar
  class HorizontalTable < BaseTable
    def render
      table.render(:unicode, options)
    end

    private

    def summary_row(value)
      super.fill(nil, 3, table.columns_size - 3)
    end

    def options
      { border: { separator: :each_row }, multiline: true, resize: resize }.tap do |hash|
        hash[:width] = Nazar.config.table.max_width if Nazar.config.table.max_width
      end
    end
  end
end
