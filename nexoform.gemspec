# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'nexoform/version'

Gem::Specification.new do |s|
  s.name        = 'nexoform'
  s.version     = Nexoform.version
  s.date        = Nexoform.date
  s.summary     = 'Environment aware wrapping for Terraform'
  s.description = 'Nexoform wraps Terraform to provide awareness for multiple environments. ' \
    'Nexoform also provides a more guided experience for using remote backends to ' \
    'track your state.  Without nexoform, there are several ways to accidentally lose ' \
    'or corrupt your current state.  Nexoform puts up guard rails to prevent ' \
    'accidents, and puts you on firm ground with terraform.'
  s.authors     = ['Ben Porter']
  s.email       = 'bporter@simplenexus.com'
  s.files       = ['lib/nexoform.rb'] + Dir['lib/nexoform/**/*']
  s.homepage    = 'https://github.com/SimpleNexus/nexoform'
  s.license     = 'MIT'

  s.required_ruby_version = '>= 2.3.0'

  s.executables << 'nexoform'

  s.add_runtime_dependency 'activesupport', '>= 5.2', '< 8.0'
  s.add_runtime_dependency 'rainbow', '~> 3.0'
  s.add_runtime_dependency 'thor', '~> 0.20.0'

  s.add_development_dependency 'byebug', '~> 10.0'
  s.add_development_dependency 'rake', '~> 12.3'
  s.add_development_dependency 'rspec', '~> 3.8'
  s.add_development_dependency 'rubocop', '~> 0.59'
end
