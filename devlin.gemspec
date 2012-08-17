# -*- encoding: utf-8 -*-
require File.expand_path('../lib/devlin/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Paul Spieker"]
  gem.email         = ["p.spieker@duenos.de"]
  gem.description   = %q{Devlin gives users the ability to define reporting database queries}
  gem.summary       = %q{Devlin gives users the ability to define reporting database queries. The queries are defined in yaml and using predefined scopes. Since the sql statements are defined by the developer, the user is not able to corrupt the database.}
  gem.homepage      = "https://github.com/spieker/devlin"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "devlin"
  gem.require_paths = ["lib"]
  gem.version       = Devlin::VERSION

  gem.add_dependency 'activerecord', '>= 3.0.0'
  gem.add_dependency 'activesupport', '>= 3.0.0'
end
