# frozen_string_literal: true

module RailsDocGenerator
  module Auth
    class << self
      # Authenticates using built-in user model with HTTP Basic Auth
      def authenticate(controller)
        controller.authenticate_or_request_with_http_basic('Documentation') do |username, password|
          user = RailsDocGenerator::User.find_by(username: username)
          user&.authenticate(password)
        end
      end
      
      # Session-based authentication (alternative approach)
      def authenticate_with_session(controller)
        if controller.session[:rails_doc_generator_user_id].present?
          user = RailsDocGenerator::User.find_by(id: controller.session[:rails_doc_generator_user_id])
          return true if user.present?
        end
        
        controller.redirect_to rails_doc_generator.login_path
      end
    end
  end
end
