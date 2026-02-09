# frozen_string_literal: true

RailsDocGenerator.configure do |config|
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
  # AUTHENTICATION (Optional - Uncomment to enable)
  # ============================================================================
  # By default, the documentation is publicly accessible.
  # Uncomment one of the strategies below to add authentication:
  
<% unless options[:skip_auth] %>
  # Strategy 1: Built-in authentication (ENABLED by default)
  # To use: run migrations and create a user:
  #   rails db:migrate
  #   RailsDocGenerator::User.create!(username: 'admin', password: 'your_secure_password')
  config.authenticate_with = proc {
    RailsDocGenerator::Auth.authenticate(self)
  }
<% else %>
  # Strategy 1: Built-in authentication (DISABLED via --skip-auth)
  # To enable: run `rails g rails_doc_generator:install` (without --skip-auth)
  # config.authenticate_with = proc {
  #   RailsDocGenerator::Auth.authenticate(self)
  # }
<% end %>
  
  # Strategy 2: HTTP Basic Auth with environment variables
  # config.authenticate_with = proc {
  #   authenticate_or_request_with_http_basic do |username, password|
  #     username == ENV['DOC_USERNAME'] && password == ENV['DOC_PASSWORD']
  #   end
  # }
  
  # Strategy 3: Devise (if you're using it)
  # config.authenticate_with = proc {
  #   authenticate_user!
  # }
  
  # Strategy 4: Custom logic
  # config.authenticate_with = proc {
  #   redirect_to root_path unless session[:admin_authenticated]
  # }
end
