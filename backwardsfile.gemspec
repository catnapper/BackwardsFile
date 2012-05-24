# -*- encoding: utf-8 -*-
require File.expand_path('../lib/backwardsfile/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Jeff Fernandez"]
  gem.email         = ["j1@jdigital.org"]
  gem.description   = %q{Reads lines from a text file in reverse order}
  gem.summary       = <<-desc
  Provides a class, BackwardsFile, that uses Enumerators to lazily read lines
  from a text file in reverse order.
  desc
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "backwardsfile"
  gem.require_paths = ["lib"]
  gem.version       = Backwardsfile::VERSION
end
