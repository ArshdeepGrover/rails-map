# Rails Doc Generator

A Ruby gem that automatically generates beautiful HTML documentation pages for your Rails application, including:

- **Routes** - All routes grouped by controller with HTTP methods, paths, and route names
- **Controllers** - Separate page for each controller with detailed route information
- **Models** - Separate page for each model with columns, associations, validations, and scopes

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rails_doc_generator'
```

And then execute:

```bash
bundle install
```

### Quick Setup (With Authentication - Default)

Run the installer:

```bash
rails g rails_doc_generator:install
rails db:migrate
```

Create an admin user:

```bash
rails c
RailsDocGenerator::User.create!(username: 'admin', password: 'your_secure_password')
```

This automatically:
- ✅ Creates `config/initializers/rails_doc_generator.rb` with authentication enabled
- ✅ Mounts the engine at `/api-doc`
- ✅ Creates migration for users table
- ✅ Adds `/doc/api` to `.gitignore`

Start your server and visit `http://localhost:3000/api-doc` - you'll be prompted to login!

### Setup Without Authentication

If you don't want authentication (development only recommended):

```bash
rails g rails_doc_generator:install --skip-auth
```

This will:
- ✅ Create the configuration file (auth disabled)
- ✅ Mount the engine at `/api-doc`
- ✅ Add `/doc/api` to `.gitignore`
- ❌ Skip creating user migration

Start your server and visit `/api-doc` - no login required!

## Usage

### Live Documentation (Recommended)

Mount the engine in your `config/routes.rb`:

```ruby
mount RailsDocGenerator::Engine, at: '/api-doc'
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

Create an initializer `config/initializers/rails_doc_generator.rb`:

```ruby
RailsDocGenerator.configure do |config|
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
  
  # Authentication (optional) - Protect documentation with authentication
  # This block will be executed in the controller context
  
  # Option 1: Built-in authentication (recommended if not using Devise)
  # Requires: rails g rails_doc_generator:install --with-auth
  config.authenticate_with = proc {
    RailsDocGenerator::Auth.authenticate(self)
  }
  
  # Option 2: Devise
  # config.authenticate_with = proc {
  #   authenticate_user!
  # }
  
  # Option 3: HTTP Basic Auth with ENV variables
  # config.authenticate_with = proc {
  #   authenticate_or_request_with_http_basic do |username, password|
  #     username == ENV['DOC_USERNAME'] && password == ENV['DOC_PASSWORD']
  #   end
  # }
  
  # Option 4: Custom logic
  # config.authenticate_with = proc {
  #   redirect_to root_path unless current_user&.admin?
  # }
end
```

## Generated Documentation

The gem generates the following HTML pages:

### Index Page (`index.html`)
- Overview with statistics (number of controllers, routes, models)
- Quick links to all controllers
- Quick links to all models

### Routes Page (`routes.html`)
- Complete list of all routes
- HTTP method badges (GET, POST, PUT, PATCH, DELETE)
- Path patterns with parameters highlighted
- Controller#Action links
- Route names

### Controller Pages (`controllers/<name>.html`)
- All routes for the specific controller
- Actions list
- Route constraints
- Default parameters

### Model Pages (`models/<name>.html`)
- Table name and primary key
- All columns with:
  - Column name
  - Data type
  - Nullable status
  - Default value
  - Additional details (limit, precision, scale)
- All associations with:
  - Association type (belongs_to, has_many, has_one, has_and_belongs_to_many)
  - Related model (with links)
  - Foreign key
  - Options (dependent, through, polymorphic, etc.)
- Validations (if enabled)
- Scopes (if enabled)

## Features

- 📱 **Responsive Design** - Works on desktop and mobile
- 🎨 **Customizable Theme** - Change the primary color to match your brand
- 🔗 **Interlinked Pages** - Easy navigation between related models and controllers
- 🏷️ **HTTP Method Badges** - Color-coded badges for different HTTP methods
- 📊 **Statistics Dashboard** - Quick overview of your application structure
- 🔍 **Association Type Badges** - Visual distinction for different association types

## Example Output

The generated documentation looks like this:

```
doc/api/
├── index.html              # Main dashboard
├── routes.html             # All routes
├── controllers/
│   ├── users.html          # UsersController routes
│   ├── posts.html          # PostsController routes
│   └── ...
└── models/
    ├── user.html           # User model details
    ├── post.html           # Post model details
    └── ...
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
