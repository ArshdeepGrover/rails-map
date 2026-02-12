# Security Policy

## Supported Versions

We release patches for security vulnerabilities. Which versions are eligible for receiving such patches depends on the CVSS v3.0 Rating:

| Version | Supported          |
| ------- | ------------------ |
| 1.2.x   | :white_check_mark: |
| 1.1.x   | :white_check_mark: |
| 1.0.x   | :x:                |
| < 1.0   | :x:                |

## Reporting a Vulnerability

We take the security of RailsMap seriously. If you believe you have found a security vulnerability, please report it to us as described below.

### Please do NOT:

- Open a public GitHub issue
- Discuss the vulnerability in public forums, social media, or mailing lists

### Please DO:

**Report security vulnerabilities via email to: arsh199820@gmail.com**

Please include the following information:

1. **Type of vulnerability** (e.g., authentication bypass, SQL injection, XSS, etc.)
2. **Full paths of source file(s)** related to the vulnerability
3. **Location of the affected source code** (tag/branch/commit or direct URL)
4. **Step-by-step instructions to reproduce** the issue
5. **Proof-of-concept or exploit code** (if possible)
6. **Impact of the vulnerability** and how an attacker might exploit it

### What to expect:

- **Acknowledgment**: We will acknowledge receipt of your vulnerability report within 48 hours
- **Communication**: We will keep you informed about the progress of fixing the vulnerability
- **Timeline**: We aim to release a fix within 30 days for critical vulnerabilities
- **Credit**: We will credit you in the security advisory (unless you prefer to remain anonymous)

## Security Best Practices

When using RailsMap in production:

### 1. Enable Authentication

Always enable authentication for production environments:

```ruby
# config/initializers/rails_map.rb
RailsMap.configure do |config|
  config.authenticate_with = proc {
    authenticate_user! # or your authentication method
  }
end
```

### 2. Restrict Access

Limit access to authorized users only:

```ruby
config.authenticate_with = proc {
  redirect_to root_path unless current_user&.admin?
}
```

### 3. Use Environment Variables

Store credentials in environment variables, not in code:

```ruby
# .env
RAILS_MAP_USERNAME=admin
RAILS_MAP_PASSWORD=secure_password_here
```

### 4. Disable in Production (Optional)

If you don't need live documentation in production, disable the engine:

```ruby
# config/routes.rb
unless Rails.env.production?
  mount RailsMap::Engine, at: '/rails-map'
end
```

### 5. Use Static HTML Generation

For production, consider using static HTML generation instead of live documentation:

```bash
rails doc:generate
# Deploy the doc/api folder to a secure location
```

### 6. Keep Updated

Always use the latest version of RailsMap to ensure you have the latest security patches:

```bash
bundle update rails_map
```

## Known Security Considerations

### Information Disclosure

RailsMap displays information about your application's structure:

- Route paths and HTTP methods
- Controller names and actions
- Model attributes and associations
- Parameter names and types

**Mitigation**: Always protect the documentation with authentication in production environments.

### Authentication Bypass

If authentication is not properly configured, unauthorized users may access your API documentation.

**Mitigation**: Follow the authentication setup guide and test your configuration.

### Cross-Site Scripting (XSS)

While we sanitize output, custom configurations might introduce XSS vulnerabilities.

**Mitigation**:

- Don't disable built-in sanitization
- Be careful with custom HTML in configuration
- Keep RailsMap updated

## Security Updates

Security updates will be released as patch versions (e.g., 1.2.1) and announced via:

- GitHub Security Advisories
- RubyGems security notifications
- CHANGELOG.md with [SECURITY] tag
- Email to reporters

## Disclosure Policy

When we receive a security bug report, we will:

1. Confirm the problem and determine affected versions
2. Audit code to find similar problems
3. Prepare fixes for all supported versions
4. Release new versions as soon as possible
5. Publish a security advisory

## Comments on this Policy

If you have suggestions on how this process could be improved, please submit a pull request or open an issue.

---

Thank you for helping keep RailsMap and its users safe! 🔒
