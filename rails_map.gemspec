# frozen_string_literal: true

require_relative "lib/rails_map/version"

Gem::Specification.new do |spec|
  spec.name          = "rails_map"
  spec.version       = RailsMap::VERSION
  spec.authors       = ["Arshdeep Singh"]
  spec.email         = ["arsh199820@gmail.com"]

  spec.summary       = "Generate interactive API documentation for Rails routes, controllers, and models"
  spec.description   = "Automatically generates interactive API documentation for Rails by mapping routes, controllers, and models. Zero configuration—just install and go."
  spec.homepage      = "https://rails-map.netlify.app"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 2.7.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/ArshdeepGrover/rails-map"
  spec.metadata["changelog_uri"] = "https://github.com/ArshdeepGrover/rails-map/blob/release/deploy/CHANGELOG.md"
  spec.metadata["bug_tracker_uri"] = "https://github.com/ArshdeepGrover/rails-map/issues"
  spec.metadata["documentation_uri"] = "https://github.com/ArshdeepGrover/rails-map#readme"
  spec.metadata["rubygems_mfa_required"] = "true"

  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rails", ">= 5.0", "< 8.0"

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
