# frozen_string_literal: true

ENV['ENABLE_TTY_COLORS'] = 'true'

require 'bundler/setup'
require 'simplecov'
SimpleCov.start

require 'nazar'
require 'csv'

module Nazar
  module SpecHelpers
    def unload_active_record!
      Nazar.extensions.delete(:active_record)

      if defined?(Nazar::Formatter::ActiveRecordCollection)
        Nazar::Formatter.send(:remove_const, :ActiveRecordCollection)
      end
      Nazar::Formatter.send(:remove_const, :ActiveRecordItem) if defined?(Nazar::Formatter::ActiveRecordItem)
    end

    def unload_csv!
      Nazar.extensions.delete(:csv)

      Nazar::Formatter.send(:remove_const, :CSVTable)
    end
  end
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.include(Nazar::SpecHelpers)
end

RSpec::Matchers.define :have_decorated_content do |text:, decorations: {}|
  match do |actual|
    pastel = Pastel.new
    data = Array.wrap(actual).map { |el| pastel.undecorate(el).first }
    texts = data.map { |el| el.delete(:text) }

    if decorations.empty?
      texts == text
    else
      texts == text && data.all? { |el| el == decorations }
    end
  end
end
