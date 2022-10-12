# frozen_string_literal: true

module Nazar
  class HorizontalTable < BaseTable
    def render
      table.render(:unicode, border: { separator: :each_row }, multiline: true, resize: false)
    end

    private

    def summary_row(value)
      super.fill(nil, 3, table.columns_size - 3)
    end
  end
end
