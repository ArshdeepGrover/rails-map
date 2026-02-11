# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- API parameter detection and display for all routes
  - Automatic extraction of path parameters (e.g., `:id`, `:user_id`)
  - Query parameter detection for GET and DELETE requests
  - Request body parameter detection for POST, PUT, and PATCH requests
  - Intelligent type inference (string, integer, boolean, datetime, email, etc.)
  - Required/optional parameter indication
  - Parameter location display (path, query, or body)
  - Expandable parameter details in routes and controller views
- Controller action analysis to extract permitted parameters
- Support for strong parameters pattern (`params.require().permit()`)
- Parameter documentation in both live and static HTML documentation

## [1.1.0] - 2026-02-10

### Added

- Live documentation via Rails Engine mounting at `/api-doc`
- Built-in authentication system (no Devise required) with `RailsMap::User` model
- Generator for easy installation: `rails g rails_map:install [--skip-auth]`
  - Authentication enabled by default for security
  - Use `--skip-auth` flag to disable authentication
  - Automatically creates configuration file
  - Automatically mounts engine in routes
  - Automatically creates user migration (unless `--skip-auth`)
  - Automatically adds `/doc/api` to `.gitignore`
- Authentication support with `authenticate_with` configuration option
- `RailsMap::Auth` helper module for authentication
- Example configuration file with authentication examples
- Comprehensive authentication guide (`AUTHENTICATION.md`)
- Quick start guide (`QUICKSTART.md`)

### Changed

- Improved card layout design with hover effects
- Better visual hierarchy for controller and model cards
- Enhanced responsive grid layout (350px min card width)
- Updated card styling with better spacing and shadows

### Fixed

- Route constraint issue preventing access to namespaced controllers
- Support for nested controller names with slashes (e.g., `admin/users`)

## [1.0.0] - 2026-02-09

### Added

- Initial release
- Route parsing and documentation generation
- Model parsing with columns, associations, validations, and scopes
- HTML documentation generation with responsive design
- Rake tasks: `doc:generate`, `doc:open`, `doc:clean`
- Customizable configuration options:
  - `output_dir` - Output directory for generated documentation
  - `app_name` - Application name displayed in documentation
  - `theme_color` - Theme color for UI customization
  - `include_timestamps` - Toggle timestamp columns in model docs
  - `include_validations` - Toggle validations in model docs
  - `include_scopes` - Toggle scopes in model docs
- Color-coded HTTP method badges (GET, POST, PUT, PATCH, DELETE)
- Association type badges (belongs_to, has_many, has_one, has_and_belongs_to_many)
- Statistics dashboard with controller, route, and model counts
- Interlinked documentation pages for easy navigation
- Dark theme UI with modern design
