# frozen_string_literal: true

require 'rails/generators'
require 'rails/generators/migration'

module RailsMap
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration
      
      source_root File.expand_path('templates', __dir__)
      
      desc "Installs RailsMap with environment-based authentication (use --skip-auth to disable)"
      
      class_option :skip_auth, type: :boolean, default: false, desc: "Skip authentication setup"
      class_option :skip_routes, type: :boolean, default: false, desc: "Skip adding route mount"
      
      def copy_initializer
        template 'initializer.rb', 'config/initializers/rails_map.rb'
      end
      
      def add_route_mount
        unless options[:skip_routes]
          route "mount RailsMap::Engine, at: '/api-doc'"
        end
      end
      
      def add_to_gitignore
        gitignore_path = '.gitignore'
        
        if File.exist?(gitignore_path)
          gitignore_content = File.read(gitignore_path)
          
          unless gitignore_content.include?('doc/api')
            append_to_file gitignore_path do
              "\n# Ignore generated documentation\n/doc/api\n"
            end
          end
        else
          create_file gitignore_path, "# Ignore generated documentation\n/doc/api\n"
        end
      end
      
      def show_readme
        readme 'README' if behavior == :invoke
      end
    end
  end
end
