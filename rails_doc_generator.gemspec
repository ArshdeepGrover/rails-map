# frozen_string_literal: true

require_relative "lib/rails_doc_generator/version"

Gem::Specification.new do |spec|
  spec.name          = "rails_doc_generator"
  spec.version       = RailsDocGenerator::VERSION
  spec.authors       = ["Your Name"]
  spec.email         = ["your.email@example.com"]

  spec.summary       = "Generate HTML documentation for Rails routes, controllers, and models"
  spec.description   = "A Ruby gem that automatically generates beautiful HTML documentation pages for your Rails application, including routes grouped by controller and model details with columns and associations."
  spec.homepage      = "https://github.com/yourusername/rails_doc_generator"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 2.7.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"

  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.files += Dir["templates/**/*"]

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rails", ">= 5.0"
  spec.add_dependency "erb", ">= 2.0"

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
