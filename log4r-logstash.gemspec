# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'log4r/logstash/version'

Gem::Specification.new do |spec|
  spec.name          = "log4r-logstash"
  spec.version       = Log4r::Logstash::VERSION
  spec.authors       = ["Christopher Baldauf"]
  spec.email         = ["cbaldauf@cimpress.com"]
  spec.summary       = %q{Ship json encoded log4r messages to logstash.}
  spec.homepage      = "http://github.com/Cimpress-MCP/log4r-logstash"
  spec.license       = "Apache 2"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.1"
  spec.add_development_dependency "rubocop", "~> 0.28"

  spec.add_runtime_dependency "log4r", "~> 1.1"
  spec.add_runtime_dependency "redis", "~> 3.2"
  spec.add_runtime_dependency "retryable", "~> 2.0"
end
