# Authentication Setup Guide

This guide shows you how to protect your Rails documentation with authentication.

## Setup Steps

### 1. Mount the Engine

In your `config/routes.rb`:

```ruby
mount RailsMap::Engine, at: '/api-doc'
```

### 2. Create Configuration File

Create `config/initializers/rails_map.rb` in your Rails application:

```ruby
RailsMap.configure do |config|
  config.app_name = 'Your App Name'
  config.theme_color = '#3B82F6'
  
  # Add authentication
  config.authenticate_with = proc {
    # Your authentication logic here
  }
end
```

## Authentication Examples

### Option 1: Built-in Authentication (Recommended)

If you don't use Devise, use the built-in authentication system.

**Setup:**

1. Install with authentication:
```bash
rails g rails_map:install
rails db:migrate
```

2. Create admin user(s):
```bash
rails c
RailsMap::User.create!(username: 'admin', password: 'your_secure_password')
RailsMap::User.create!(username: 'developer', password: 'another_password')
```

3. Enable in configuration:
```ruby
config.authenticate_with = proc {
  RailsMap::Auth.authenticate(self)
}
```

4. Restart server and visit `/api-doc` - you'll be prompted for username/password

**Managing Users:**

```ruby
# Create user
RailsMap::User.create!(username: 'john', password: 'password123')

# Update password
user = RailsMap::User.find_by(username: 'john')
user.update!(password: 'new_password')

# Delete user
RailsMap::User.find_by(username: 'john').destroy

# List all users
RailsMap::User.all.pluck(:username)
```

### Option 2: Devise Authentication

If you're using Devise:

```ruby
config.authenticate_with = proc {
  authenticate_user!
}
```

Or restrict to admins only:

```ruby
config.authenticate_with = proc {
  authenticate_user!
  redirect_to root_path, alert: 'Not authorized' unless current_user.admin?
}
```

### Option 3: HTTP Basic Authentication

Simple username/password protection:

```ruby
config.authenticate_with = proc {
  authenticate_or_request_with_http_basic do |username, password|
    username == 'admin' && password == 'secret'
  end
}
```

With environment variables (recommended):

```ruby
config.authenticate_with = proc {
  authenticate_or_request_with_http_basic do |username, password|
    username == ENV['DOC_USERNAME'] && password == ENV['DOC_PASSWORD']
  end
}
```

### Option 4: Environment-Based Protection

Protect only in production:

```ruby
config.authenticate_with = proc {
  if Rails.env.production?
    authenticate_or_request_with_http_basic do |username, password|
      username == ENV['DOC_USERNAME'] && password == ENV['DOC_PASSWORD']
    end
  end
}
```

### Option 5: Custom Authentication Logic

Use any custom logic:

```ruby
config.authenticate_with = proc {
  # Check session
  unless session[:authenticated]
    redirect_to login_path
    return
  end
  
  # Check user role
  unless current_user&.has_role?(:developer)
    render plain: 'Unauthorized', status: :unauthorized
  end
}
```

### Option 6: IP Whitelist

Restrict by IP address:

```ruby
config.authenticate_with = proc {
  allowed_ips = ['127.0.0.1', '::1', '10.0.0.0/8']
  
  unless allowed_ips.any? { |ip| IPAddr.new(ip).include?(request.remote_ip) }
    render plain: 'Forbidden', status: :forbidden
  end
}
```

## Testing Authentication

After configuring authentication:

1. Restart your Rails server
2. Visit `http://localhost:3000/api-doc`
3. You should be prompted to authenticate

## No Authentication (Development Only)

To disable authentication during development, simply don't set `authenticate_with` or use:

```ruby
config.authenticate_with = nil
```

Or conditionally:

```ruby
unless Rails.env.development?
  config.authenticate_with = proc {
    # Your auth logic
  }
end
```

## Troubleshooting

### Infinite Redirect Loop

Make sure your authentication logic doesn't redirect to itself:

```ruby
# BAD - will cause infinite loop if not careful
config.authenticate_with = proc {
  redirect_to login_path unless logged_in?
}

# GOOD - check if already on login page
config.authenticate_with = proc {
  redirect_to login_path unless logged_in? || request.path == login_path
}
```

### Helper Methods Not Available

The authentication block runs in the controller context, so you have access to:
- `request`
- `session`
- `cookies`
- `params`
- `redirect_to`
- `render`
- Any helper methods from your application

If a method isn't available, you may need to include it in the engine controller or use a different approach.
