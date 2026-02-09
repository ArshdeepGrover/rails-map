# Quick Start Guide

Get up and running with RailsDocGenerator in under 5 minutes!

## Installation

Add to your `Gemfile`:

```ruby
gem 'rails_doc_generator'
```

Then run:

```bash
bundle install
```

## Setup

### Default Installation (With Authentication - Recommended)

1. Run the generator:
```bash
rails g rails_doc_generator:install
rails db:migrate
```

This automatically:
- ✅ Creates `config/initializers/rails_doc_generator.rb` with auth enabled
- ✅ Mounts the engine in `config/routes.rb`
- ✅ Creates user migration
- ✅ Adds `/doc/api` to `.gitignore`

2. Create an admin user:
```bash
rails c
RailsDocGenerator::User.create!(username: 'admin', password: 'your_secure_password')
exit
```

3. Start your server:
```bash
rails s
```

4. Visit `http://localhost:3000/api-doc` and login with your credentials

**That's it!** 🎉 Secure by default!

---

### Skip Authentication (Development Only)

1. Run the generator with --skip-auth flag:
```bash
rails g rails_doc_generator:install --skip-auth
```

2. Start your server:
```bash
rails s
```

3. Visit: `http://localhost:3000/api-doc`

**No authentication required!** Use only in development.

---

## Customization

### Change Theme Color

In `config/initializers/rails_doc_generator.rb`:

```ruby
config.theme_color = '#FF6B6B'  # Any valid CSS color
```

### Change App Name

```ruby
config.app_name = 'My Awesome API'
```

### Hide Timestamps in Models

```ruby
config.include_timestamps = false
```

## Managing Users (Built-in Auth)

### Create User
```ruby
RailsDocGenerator::User.create!(username: 'developer', password: 'password123')
```

### Change Password
```ruby
user = RailsDocGenerator::User.find_by(username: 'developer')
user.update!(password: 'new_password')
```

### Delete User
```ruby
RailsDocGenerator::User.find_by(username: 'developer').destroy
```

### List All Users
```ruby
RailsDocGenerator::User.all.pluck(:username)
```

## Static HTML Generation (Optional)

If you want to generate static HTML files instead of using the live engine:

```bash
rails doc:generate  # Generate HTML files
rails doc:open      # Open in browser
rails doc:clean     # Remove generated files
```

Files are generated in `doc/api/` by default.

## Troubleshooting

### Can't access /api-doc
- Make sure you've mounted the engine in `config/routes.rb`
- Restart your Rails server

### Authentication not working
- Verify you've run migrations: `rails db:migrate`
- Check that you've created a user
- Ensure authentication is enabled in the initializer

### Controllers with slashes not showing
- Update the gem to the latest version
- The route constraint issue has been fixed

## Next Steps

- Read [AUTHENTICATION.md](AUTHENTICATION.md) for advanced authentication options
- Read [README.md](README.md) for complete documentation
- Customize your theme color and app name
- Add authentication for production deployments

## Need Help?

- Check the [README.md](README.md) for detailed documentation
- Review [AUTHENTICATION.md](AUTHENTICATION.md) for authentication setup
- Open an issue on GitHub
