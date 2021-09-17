# frozen_string_literal: true

require 'dry-configurable'
require 'terminal-table'
require 'pastel'
require 'tty-pager'

require 'nazar/version'
require 'nazar/cell_formatter'
require 'nazar/headers_formatter'
require 'nazar/renderer'
require 'nazar/formatter'
require 'nazar/view'
require 'nazar/formatter/csv_table'

module Nazar
  extend Dry::Configurable

  setting :formatter do
    setting :nil, default: '∅'
    setting :boolean, default: ['✓', '✗']
  end

  def self.enable!
    # TODO: enable Nazar
  end

  def self.disable!
    # TODO: disable Nazar
  end
end
