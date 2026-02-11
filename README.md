# Rails Map

🌐 **[Homepage](https://rails-map.netlify.app)** | 📦 **[RubyGems](https://rubygems.org/gems/rails_map)** | 🐙 **[GitHub](https://github.com/ArshdeepGrover/rails-map)**

Automatically generates interactive API documentation for Rails by mapping routes, controllers, and models. Zero configuration—just install and go.

- **Routes** - All routes grouped by controller with HTTP methods, paths, and route names
- **Controllers** - Separate page for each controller with detailed route information
- **Models** - Separate page for each model with columns, associations, validations, and scopes

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rails_map'
```

And then execute:

```bash
bundle install
```

### Quick Setup (With Authentication - Default)

Run the installer:

```bash
rails g rails_map:install
```

Set environment variables (optional):

```bash
export RAILS_MAP_USERNAME=admin
export RAILS_MAP_PASSWORD=your_secure_password
```

Or add to `.env` file:

```
RAILS_MAP_USERNAME=admin
RAILS_MAP_PASSWORD=your_secure_password
```

This automatically:

- ✅ Creates `config/initializers/rails_map.rb` with authentication enabled
- ✅ Mounts the engine at `/api-doc`
- ✅ Adds `/doc/api` to `.gitignore`
- ✅ Uses default credentials (admin/password) if ENV variables not set

Start your server and visit `http://localhost:3000/api-doc` - you'll be prompted to login!

### Setup Without Authentication

If you don't want authentication (development only recommended):

```bash
rails g rails_map:install --skip-auth
```

This will:

- ✅ Create the configuration file (auth disabled)
- ✅ Mount the engine at `/api-doc`
- ✅ Add `/doc/api` to `.gitignore`

Start your server and visit `/api-doc` - no login required!

## Usage

### Live Documentation (Recommended)

Mount the engine in your `config/routes.rb`:

```ruby
mount RailsMap::Engine, at: '/api-doc'
```

Then visit `http://localhost:3000/api-doc` in your browser to see live documentation.

### Static HTML Generation

Run the following rake task to generate static HTML documentation:

```bash
rails doc:generate
```

This will generate HTML documentation in `doc/api/` directory.

### Open Documentation in Browser

```bash
rails doc:open
```

### Clean Generated Documentation

```bash
rails doc:clean
```

## Configuration

Create an initializer `config/initializers/rails_map.rb`:

```ruby
RailsMap.configure do |config|
  # Output directory for generated documentation
  config.output_dir = Rails.root.join('doc', 'api').to_s

  # Application name displayed in the documentation
  config.app_name = 'My Application'

  # Theme color (any valid CSS color)
  config.theme_color = '#3B82F6'

  # Include timestamp columns (created_at, updated_at) in model documentation
  config.include_timestamps = true

  # Include model validations in documentation
  config.include_validations = true

  # Include model scopes in documentation
  config.include_scopes = true

  # Authentication - Protect documentation with authentication
  # Uses environment variables: RAILS_MAP_USERNAME and RAILS_MAP_PASSWORD
  # Defaults to username: admin, password: password

  config.authenticate_with = proc {
    RailsMap::Auth.authenticate(self)
  }

  # Option 2: Devise
  # config.authenticate_with = proc {
  #   authenticate_user!
  # }

  # Option 3: Custom logic
  # config.authenticate_with = proc {
  #   redirect_to root_path unless current_user&.admin?
  # }
end
```

## Features

- 📱 **Responsive Design** - Works on desktop and mobile
- 🎨 **Customizable Theme** - Change the primary color to match your brand
- 🔗 **Interlinked Pages** - Easy navigation between related models and controllers
- 🏷️ **HTTP Method Badges** - Color-coded badges for different HTTP methods
- 📊 **Statistics Dashboard** - Quick overview of your application structure
- 🔍 **Association Type Badges** - Visual distinction for different association types
- 📝 **API Parameter Detection** - Automatically extracts and displays parameters for each route
  - Path parameters (`:id`, `:user_id`, etc.)
  - Query parameters for GET/DELETE requests
  - Request body parameters for POST/PUT/PATCH requests
  - Type inference (string, integer, boolean, datetime, etc.)
  - Required/optional indication
  - Parameter location (path, query, body)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ArshdeepGrover/rails-map.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
