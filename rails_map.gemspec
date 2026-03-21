# frozen_string_literal: true

require_relative "lib/rails_map/version"

Gem::Specification.new do |spec|
  spec.name          = "rails_map"
  spec.version       = RailsMap::VERSION
  spec.authors       = ["Arshdeep Singh"]
  spec.email         = ["arsh199820@gmail.com"]

  spec.summary       = "Generate interactive API documentation for Rails routes, controllers, and models"
  spec.description   = <<~DESC
    RailsMap automatically generates beautiful, interactive API documentation for your Rails application.
    
    Features:
    • Live documentation via Rails Engine at /rails-map
    • Static HTML generation for offline use
    • Automatic parameter detection (path, query, body)
    • Route documentation with HTTP methods and paths
    • Controller documentation with actions and parameters
    • Model documentation with columns, associations, validations, and scopes
    • Built-in authentication support
    • Customizable themes and colors
    • Zero configuration - just install and go!
    
    Perfect for API development, team collaboration, and maintaining up-to-date documentation.
  DESC
  spec.homepage      = "https://rails-map.netlify.app"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 2.7.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/ArshdeepGrover/rails-map"
  spec.metadata["changelog_uri"] = "https://github.com/ArshdeepGrover/rails-map/blob/release/deploy/CHANGELOG.md"
  spec.metadata["bug_tracker_uri"] = "https://github.com/ArshdeepGrover/rails-map/issues"
  spec.metadata["documentation_uri"] = "https://github.com/ArshdeepGrover/rails-map#readme"
  spec.metadata["wiki_uri"] = "https://github.com/ArshdeepGrover/rails-map/wiki"
  spec.metadata["funding_uri"] = "https://github.com/sponsors/ArshdeepGrover"
  spec.metadata["rubygems_mfa_required"] = "true"
  
  # Additional metadata for better discoverability
  spec.metadata["allowed_push_host"] = "https://rubygems.org"
  spec.metadata["github_repo"] = "ssh://github.com/ArshdeepGrover/rails-map"
  
  # Post-install message
  spec.post_install_message = <<~MSG
    
    ╔═══════════════════════════════════════════════════════════════╗
    ║                                                               ║
    ║   Thanks for installing RailsMap! 🎉                          ║
    ║                                                               ║
    ║   Get started:                                                ║
    ║   $ rails g rails_map:install                                 ║
    ║                                                               ║
    ║   Then visit: http://localhost:3000/rails-map                 ║
    ║                                                               ║
    ║   Documentation: https://rails-map.netlify.app                ║
    ║   GitHub: https://github.com/ArshdeepGrover/rails-map         ║
    ║                                                               ║
    ║   New in v1.2.0: Automatic API parameter detection! 🚀        ║
    ║                                                               ║
    ╚═══════════════════════════════════════════════════════════════╝
    
  MSG

  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rails", ">= 5.0", "< 9.0"

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
