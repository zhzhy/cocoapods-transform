# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cocoapods-transform/gem_version.rb'

Gem::Specification.new do |spec|
  spec.name          = 'cocoapods-transform'
  spec.version       = CocoapodsTransform::VERSION
  spec.authors       = ['张朝阳']
  spec.email         = ['zhzhy@158.com']
  spec.description   = %q{Transform Podfile between source Code and Framework}
  spec.summary       = %q{Transform Podfile between source Code and Framework.}
  spec.homepage      = 'https://github.com/zhzhy/cocoapods-generator'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency "cocoapods", "~> 0.39"
  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
end
