lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'heartcheck/version'

Gem::Specification.new do |spec|
  spec.name = 'heartcheck'
  spec.version = Heartcheck::VERSION
  spec.authors = ['Locaweb']
  spec.email = ['desenvolvedores@locaweb.com.br']
  spec.homepage = 'http://developer.locaweb.com.br'
  spec.summary = 'A simple way to check if your app is runnig like as expected.'
  spec.description = 'A simple way to check your app heart.'
  spec.license =  'MIT'

  spec.files = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'rack', '~> 1', '>= 1.4.0'
  spec.add_runtime_dependency 'oj'
  spec.add_runtime_dependency 'net-telnet', '~> 0.1.1'

  spec.add_development_dependency 'pry-nav', '~> 0.2.0', '>= 0.2.4'
  spec.add_development_dependency 'rspec', '~> 3.1.0', '>= 3.1.0'
  spec.add_development_dependency 'rubocop', '~> 0.27.0', '>= 0.27.1'
  spec.add_development_dependency 'thor', '~> 0.19.0', '>= 0.19.1'
  spec.add_development_dependency 'rack-test', '~> 0.6.0', '>= 0.6.3'
  # for documentation
  spec.add_development_dependency 'yard', '~> 0.8.0', '>= 0.8.7.6'
  spec.add_development_dependency 'concurrent-ruby', '~> 0.9.1', '>= 0.9.1'
end
