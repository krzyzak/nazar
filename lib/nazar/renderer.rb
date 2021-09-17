# frozen_string_literal: true

module Nazar
  class Renderer
    def initialize(data)
      @data = data
    end

    def render
      pager.page(view.render) if view.supported_data?
    end

    def render!
      render || data
    end

    def pager
      @pager ||= TTY::Pager::SystemPager.new(command: 'less -iMSx4 -FX')
    end

    private

    attr_reader :data

    def render_table?
      view.enabled?
    end

    def view
      @view ||= View.new(data)
    end
  end
end
