# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'flexcon/version'

Gem::Specification.new do |spec|
  spec.name          = "flexcon"
  spec.version       = Flexcon::VERSION
  spec.authors       = ["Rodette Pedro"]
  spec.email         = ["rodettcpedro@gmail.com"]

  spec.summary       = "Demand Lambda Arguments from a Scope"
  spec.description   = "Extract properties of a scope and pass it to a lambda function."
  spec.homepage      = "https://github.com/rcpedro/flexcon"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.1.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
