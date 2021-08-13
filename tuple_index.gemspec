# frozen_string_literal: true

require_relative "lib/tuple_index/version"

Gem::Specification.new do |spec|
  spec.name          = "tuple_index"
  spec.version       = TupleIndex::VERSION
  spec.authors       = ["Dylan Blakemore"]
  spec.email         = ["dylan.blakemore@gmail.com"]

  spec.summary       = "Easy tuple manipulation."
  # spec.description   = "TODO: Write a longer description or delete this line."
  spec.homepage      = "https://github.com/DylanBlakemore/"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 2.4.0"

  spec.metadata["allowed_push_host"] = "https://mygemserver.com"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/DylanBlakemore/tuple_index"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html

  spec.add_runtime_dependency "activesupport"
end
