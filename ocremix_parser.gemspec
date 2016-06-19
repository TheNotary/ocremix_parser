# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ocremix_parser/version'

Gem::Specification.new do |spec|
  spec.name          = "ocremix_parser"
  spec.version       = OcremixParser::VERSION
  spec.authors       = ["TheNotary"]
  spec.email         = ["no@email.plz"]

  spec.summary       = %q{This .}
  spec.description   = %q{: Write a longer description or delete this line.}

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "figaro"
  spec.add_dependency "simple-rss"

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry"
end
