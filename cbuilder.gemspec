# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.name          = "cbuilder"
  gem.version       = "0.0.1"
  gem.authors       = ["Nate Berkopec"]
  gem.email         = ["nate.berkopec@gmail.com"]
  gem.summary   = "Create CSV structures with a Builder-style DSL"
  gem.homepage      = "http://github.com/nateberkopec/cbuilder"

  gem.add_dependency 'blankslate', '>= 2.1.2.4'
  gem.add_dependency 'activesupport', '>= 3.0.0'

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
