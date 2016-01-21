# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'aes_keeper/version'

Gem::Specification.new do |spec|
  spec.name          = "aes_keeper"
  spec.version       = AesKeeper::VERSION
  spec.authors       = ["Daniel P. Clark"]
  spec.email         = ["6ftdan@gmail.com"]
  spec.summary       = %q{Encrypt data via AES to database worthy strings.}
  spec.description   = %q{Encrypt data to strings via AES 256bit encryption. Database string safe.}
  spec.homepage      = "https://github.com/danielpclark/aes_keeper"
  spec.license       = "MIT"
  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '~> 2.0'

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.8"
  spec.add_development_dependency "minitest-reporters", "~> 1.1.7"
  spec.add_development_dependency "color_pound_spec_reporter", "~> 0.0.5"
  spec.add_runtime_dependency "armor", "~> 0.0"
end
