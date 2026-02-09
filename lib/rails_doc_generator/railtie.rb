# frozen_string_literal: true

require "rails/railtie"

module RailsDocGenerator
  class Railtie < Rails::Railtie
    railtie_name :rails_doc_generator

    rake_tasks do
      namespace :doc do
        desc "Generate HTML documentation for routes and models"
        task generate: :environment do
          puts "Generating documentation..."
          RailsDocGenerator.generate
        end

        desc "Generate documentation and open in browser"
        task open: :generate do
          index_path = File.join(RailsDocGenerator.configuration.output_dir, "index.html")
          
          if File.exist?(index_path)
            system("open", index_path) || system("xdg-open", index_path) || system("start", index_path)
          else
            puts "Documentation not found at #{index_path}"
          end
        end

        desc "Clean generated documentation"
        task clean: :environment do
          output_dir = RailsDocGenerator.configuration.output_dir
          if Dir.exist?(output_dir)
            FileUtils.rm_rf(output_dir)
            puts "Removed documentation at #{output_dir}"
          else
            puts "No documentation found at #{output_dir}"
          end
        end
      end
    end

    # Allow configuration via Rails initializer
    initializer "rails_doc_generator.configure" do
      # Configuration can be done in config/initializers/rails_doc_generator.rb
    end
  end
end
