# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "terminal-share"

Gem::Specification.new do |s|
  s.name        = "terminal-share"
  s.authors     = ["Mattt Thompson"]
  s.email       = "m@mattt.me"
  s.license     = "MIT"
  s.homepage    = "http://mattt.me"
  s.version     = TerminalShare::VERSION
  s.platform    = Gem::Platform::RUBY
  s.summary     = "terminal-share"
  s.description = "A command-line interface to the Mac OS X Sharing Services"

  s.add_development_dependency "rspec", "~> 0.6.1"
  s.add_development_dependency "rake",  "~> 0.9.2"

  s.files         = Dir["./**/*"].reject{|file| file =~ /\.\/(bin|log|pkg|script|spec|test|vendor)/}
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{|f| File.basename(f)}
  s.require_paths = ["lib"]
end
