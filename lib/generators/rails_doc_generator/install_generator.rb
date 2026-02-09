# frozen_string_literal: true

require 'rails/generators'
require 'rails/generators/migration'

module RailsDocGenerator
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration
      
      source_root File.expand_path('templates', __dir__)
      
      desc "Installs RailsDocGenerator with built-in authentication (use --skip-auth to disable)"
      
      class_option :skip_auth, type: :boolean, default: false, desc: "Skip built-in authentication setup"
      class_option :skip_routes, type: :boolean, default: false, desc: "Skip adding route mount"
      
      def self.next_migration_number(path)
        Time.now.utc.strftime("%Y%m%d%H%M%S")
      end
      
      def copy_initializer
        template 'initializer.rb', 'config/initializers/rails_doc_generator.rb'
      end
      
      def create_migration_file
        unless options[:skip_auth]
          migration_template 'migration.rb', 'db/migrate/create_rails_doc_generator_users.rb'
        end
      end
      
      def add_route_mount
        unless options[:skip_routes]
          route "mount RailsDocGenerator::Engine, at: '/api-doc'"
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
