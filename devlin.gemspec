# -*- encoding: utf-8 -*-
require File.expand_path('../lib/devlin/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Paul Spieker"]
  gem.email         = ["p.spieker@duenos.de"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "devlin"
  gem.require_paths = ["lib"]
  gem.version       = Devlin::VERSION

  gem.add_dependency 'activerecord', '>= 3.0.0'
  gem.add_dependency 'activesupport', '>= 3.0.0'
end
