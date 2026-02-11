# frozen_string_literal: true

module RailsMap
  module Auth
    class << self
      # Authenticates using environment variables with HTTP Basic Auth
      def authenticate(controller)
        controller.authenticate_or_request_with_http_basic('Documentation') do |username, password|
          username == (ENV['RAILS_MAP_USERNAME'] || 'admin') && 
          password == (ENV['RAILS_MAP_PASSWORD'] || 'password')
        end
      end
    end
  end
end
