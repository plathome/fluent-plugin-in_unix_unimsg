# coding: utf-8
Gem::Specification.new do |spec|
  spec.name          = "fluent-plugin-in_unix_unimsg"
  spec.version       = "0.0.1"
  spec.authors       = ["Kohei MATSUSHITA"]
  spec.email         = ["ma2shita+git@ma2shita.jp"]
  spec.summary       = %q{Processing a uni message via Unix Domain Socket}
  spec.description   = %q{Processing a uni message via Unix Domain Socket}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_dependency "fluentd"
end
