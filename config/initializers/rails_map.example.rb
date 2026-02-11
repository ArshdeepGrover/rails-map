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
  
  # ============================================================================
  # AUTHENTICATION
  # ============================================================================
  # Set RAILS_MAP_USERNAME and RAILS_MAP_PASSWORD environment variables
  # to enable authentication. Leave them unset for public access.
  
  config.authenticate_with = proc {
    RailsMap::Auth.authenticate(self)
  }
  
  # Alternative: Devise authentication
  # config.authenticate_with = proc {
  #   authenticate_user!
  # }
  
  # Alternative: Custom logic
  # config.authenticate_with = proc {
  #   redirect_to root_path unless current_user&.admin?
  # }
end
