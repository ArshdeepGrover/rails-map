# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]

### Added
- Live documentation via Rails Engine mounting at `/api-doc`
- Built-in authentication system (no Devise required) with `RailsDocGenerator::User` model
- Generator for easy installation: `rails g rails_doc_generator:install [--skip-auth]`
  - **Authentication enabled by default** for security
  - Use `--skip-auth` flag to disable authentication
  - Automatically creates configuration file
  - Automatically mounts engine in routes  
  - Automatically creates user migration (unless --skip-auth)
  - Automatically adds `/doc/api` to `.gitignore`
- Authentication support with `authenticate_with` configuration option
- `RailsDocGenerator::Auth` helper module for authentication
- Improved card layout design with hover effects
- Better visual hierarchy for controller and model cards
- Support for nested controller names with slashes (e.g., `action_mailbox/ingresses`)
- Example configuration file with authentication examples
- Comprehensive authentication guide (AUTHENTICATION.md)

### Changed
- Improved responsive grid layout (350px min card width)
- Enhanced card styling with better spacing and shadows
- Card titles now truncate with ellipsis for long names
- Updated README with live documentation setup and authentication examples

### Fixed
- Route constraint issue preventing access to namespaced controllers

## [1.0.0] - 09/02/2026

### Added
- Initial release
- Route parsing and documentation generation
- Model parsing with columns, associations, validations, and scopes
- HTML documentation generation with responsive design
- Rake tasks: `doc:generate`, `doc:open`, `doc:clean`
- Customizable configuration options
- Color-coded HTTP method badges
- Association type badges
- Statistics dashboard
- Interlinked documentation pages
