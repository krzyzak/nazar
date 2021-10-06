# frozen_string_literal: true

require_relative 'lib/nazar/version'

Gem::Specification.new do |spec| # rubocop:disable Metrics/BlockLength
  spec.name          = 'nazar'
  spec.version       = Nazar::VERSION
  spec.authors       = ['Michał Krzyżanowski']
  spec.email         = ['michal.krzyzanowski+github@gmail.com']
  spec.licenses      = ['MIT']

  spec.summary       = 'Nazar is a tool that enhances default IRB/Pry inspect output'
  spec.homepage      = 'https://github.com/krzyzak/nazar'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.7.0')

  spec.metadata['homepage_uri'] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.cert_chain  = ['certs/krzyzak.pem']
  spec.signing_key = File.expand_path('~/.ssh/gem-private_key.pem') if $PROGRAM_NAME =~ /gem\z/

  spec.add_development_dependency 'activerecord', '>= 3.0', '< 6.2'
  spec.add_development_dependency 'rubocop', '~> 1.21'
  spec.add_development_dependency 'sequel', '~> 5.0'
  spec.add_development_dependency 'simplecov', '~> 0.20'
  spec.add_development_dependency 'sqlite3', '~> 1.0'

  spec.add_runtime_dependency 'dry-configurable', '~> 0.12'
  spec.add_runtime_dependency 'pastel', '~> 0.8'
  spec.add_runtime_dependency 'terminal-table', '~> 3.0'
  spec.add_runtime_dependency 'tty-pager', '~> 0.14'
end
