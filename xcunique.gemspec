# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'xcunique/version'

Gem::Specification.new do |spec|
  spec.name          = "xcunique"
  spec.version       = Xcunique::VERSION
  spec.authors       = ["Paul Samuels"]
  spec.email         = ["paulio1987@gmail.com"]
  spec.summary       = %q{A tool to reduce merge conflicts with Xcode projects by creating deterministic UUIDs for every element within the `project.pbxproj` file.}
  spec.description   = %q{A tool to reduce merge conflicts with Xcode projects by creating deterministic UUIDs for every element within the `project.pbxproj` file.}
  spec.homepage      = "https://github.com/paulsamuels/xcunique"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-minitest"
  spec.add_development_dependency "yard"
end
