# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)
require 'terminal-share'

Gem::Specification.new do |s|
  s.name        = 'terminal-share'
  s.authors     = ['Mattt']
  s.email       = 'mattt@me.com'
  s.license     = 'MIT'
  s.homepage    = 'https://mat.tt'
  s.version     = TerminalShare::VERSION
  s.platform    = Gem::Platform::RUBY
  s.summary     = 'terminal-share'
  s.description = 'A command-line interface to the macOS Sharing Services'

  s.add_development_dependency "rake",  "~> 13.0.1"

  s.files         = Dir['./**/*'].reject { |file| file =~ %r{\./(bin|log|pkg|script|spec|test|vendor)} }
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = ['lib']
end
