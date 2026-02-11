# frozen_string_literal: true

RailsMap.configure do |config|
  # Application name displayed in the documentation
  config.app_name = '<%= Rails.application.class.module_parent_name %>'
  
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

  <% unless options[:skip_auth] %>
    config.authenticate_with = proc {
      RailsMap::Auth.authenticate(self)
    }
  <% else %>
    # Authentication disabled via --skip-auth flag
    # To enable: Set RAILS_MAP_USERNAME and RAILS_MAP_PASSWORD environment variables
    # and uncomment the line below:
    # config.authenticate_with = proc { RailsMap::Auth.authenticate(self) }
  <% end %>
end
