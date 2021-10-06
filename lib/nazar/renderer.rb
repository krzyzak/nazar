# frozen_string_literal: true

module Nazar
  class Renderer
    def initialize(data, use_generic_formatter: false)
      @data = data
      @use_generic_formatter = use_generic_formatter
    end

    def render
      pager.page(view.render)
      nil
    end

    def valid?
      view.supported_data?
    end

    def pager
      @pager ||= TTY::Pager::SystemPager.new(command: 'less -iMSx4 -FX')
    end

    private

    attr_reader :data

    def view
      @view ||= View.new(data, use_generic_formatter: @use_generic_formatter)
    end
  end
end
