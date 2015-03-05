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

  spec.files = Dir['lib/**/*'].select { |f| File.file?(f) } << "bin/heartcheck"
  spec.test_files = spec.files.grep(/^spec\//)
  spec.executables = Dir['bin/*']
    .flat_map { |f| f.split("\n").map { |file| File.basename(file) } }
  spec.require_paths = %w(lib)

  spec.add_runtime_dependency 'rack', '~> 1', '>= 1.4.0'
  spec.add_runtime_dependency 'oj', '~> 2.11.0', '>= 2.11.4'

  spec.add_development_dependency 'pry-nav', '~> 0.2.0', '>= 0.2.4'
  spec.add_development_dependency 'rspec', '~> 3.1.0', '>= 3.1.0'
  spec.add_development_dependency 'rubocop', '~> 0.27.0', '>= 0.27.1'
  spec.add_development_dependency 'thor', '~> 0.19.0', '>= 0.19.1'
  spec.add_development_dependency 'rack-test', '~> 0.6.0', '>= 0.6.3'
  # for documentation
  spec.add_development_dependency 'yard', '~> 0.8.0', '>= 0.8.7'
  spec.add_development_dependency 'redcarpet', '~> 3.2.0', '>= 3.2.2'
end
