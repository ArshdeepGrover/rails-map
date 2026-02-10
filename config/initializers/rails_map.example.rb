# frozen_string_literal: true

# Example configuration for RailsMap
# Copy this file to your Rails application's config/initializers/rails_map.rb

RailsMap.configure do |config|
  # Application name displayed in the documentation
  config.app_name = 'My Application'
  
  # Theme color (any valid CSS color)
  config.theme_color = '#3B82F6'
  
  # Output directory for static HTML generation
  config.output_dir = Rails.root.join('doc', 'api').to_s
  
  # Include timestamp columns (created_at, updated_at) in model documentation
  config.include_timestamps = true
  
  # Include model validations in documentation
  config.include_validations = true
  
  # Include model scopes in documentation
  config.include_scopes = true
  
  # Authentication (optional) - Protect documentation with authentication
  # Uncomment and customize one of the examples below:
  
  # Example 1: Devise authentication
  # config.authenticate_with = proc {
  #   authenticate_user!
  # }
  
  # Example 2: HTTP Basic Auth
  # config.authenticate_with = proc {
  #   authenticate_or_request_with_http_basic do |username, password|
  #     username == ENV['DOC_USERNAME'] && password == ENV['DOC_PASSWORD']
  #   end
  # }
  
  # Example 3: Custom admin check
  # config.authenticate_with = proc {
  #   redirect_to root_path, alert: 'Not authorized' unless current_user&.admin?
  # }
  
  # Example 4: Environment-based protection (only in production)
  # config.authenticate_with = proc {
  #   if Rails.env.production?
  #     authenticate_or_request_with_http_basic do |username, password|
  #       username == ENV['DOC_USERNAME'] && password == ENV['DOC_PASSWORD']
  #     end
  #   end
  # }
end
