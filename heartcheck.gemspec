lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'heartcheck/version'

Gem::Specification.new do |spec|
  spec.name = 'heartcheck'
  spec.version = Heartcheck::VERSION
  spec.authors = ['Locaweb']
  spec.email = ['desenvolvedores@locaweb.com.br']
  spec.homepage = 'http://github.com/locaweb/heartcheck/'
  spec.summary = 'A simple way to check if your app is runnig like as expected.'
  spec.description = 'A simple way to check your app heart.'
  spec.license =  'MIT'

  spec.files = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'rack', '>= 1.4.0', '< 2.1'
  spec.add_runtime_dependency 'multi_json', '~> 1.0'
  spec.add_runtime_dependency 'net-telnet', '~> 0.1.1'
  spec.add_runtime_dependency 'sys-uname', '~> 1.0', '>= 1.0.3'

  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'pry-nav', '~> 0.2.4'
  spec.add_development_dependency 'rspec', '~> 3.5.0'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'thor', '~> 0.19.1'
  spec.add_development_dependency 'rack-test', '~> 0.6.3'
  spec.add_development_dependency 'oj', '~> 2.17.1'
  spec.add_development_dependency 'yard', '~> 0.9.5'
  spec.add_development_dependency 'concurrent-ruby', '~> 1.0.2'
end
