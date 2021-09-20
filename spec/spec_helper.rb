# frozen_string_literal: true

require 'bundler/setup'
require 'nazar'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
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
