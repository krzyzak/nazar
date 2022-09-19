# frozen_string_literal: true

module Nazar
  class Renderer
    def initialize(data, layout:, paginate:, use_generic_formatter: false)
      @data = data
      @use_generic_formatter = use_generic_formatter
      @layout = layout
      @paginate = paginate
    end

    def render
      if paginate || view.horizontal?
        pager.page(view.render)
      else
        puts view.render
      end
      nil
    end

    def valid?
      view.supported_data?
    end

    def pager
      @pager ||= TTY::Pager::SystemPager.new(command: 'less -iMSx4 -FX')
    end

    private

    attr_reader :data, :use_generic_formatter, :layout, :paginate

    def view
      @view ||= View.new(data, use_generic_formatter: use_generic_formatter, layout: layout)
    end
  end
end
