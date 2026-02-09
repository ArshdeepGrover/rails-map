# frozen_string_literal: true

require "erb"
require "fileutils"

module RailsDocGenerator
  module Generators
    class HtmlGenerator
      attr_reader :routes, :models, :output_dir

      TEMPLATES_DIR = File.expand_path("../../../templates", __dir__)

      def initialize(routes:, models:, output_dir:)
        @routes = routes
        @models = models
        @output_dir = output_dir
      end

      def generate_all
        generate_index
        generate_routes_page
        generate_controller_pages
        generate_model_pages
      end

      private

      def generate_index
        content = render_template("index", binding_for_index)
        write_page("index.html", "Home", content)
      end

      def generate_routes_page
        content = render_template("routes", binding_for_routes)
        write_page("routes.html", "All Routes", content)
      end

      def generate_controller_pages
        routes.each do |controller_name, data|
          content = render_template("controller", binding_for_controller(controller_name, data))
          filename = "controllers/#{controller_name.gsub('/', '_')}.html"
          write_page(filename, "#{controller_name.camelize}Controller", content)
        end
      end

      def generate_model_pages
        models.each do |name, model|
          content = render_template("model", binding_for_model(model))
          filename = "models/#{name.underscore.gsub('/', '_')}.html"
          write_page(filename, name, content)
        end
      end

      def render_template(name, template_binding)
        template_path = File.join(TEMPLATES_DIR, "#{name}.html.erb")
        template = ERB.new(File.read(template_path), trim_mode: "-")
        template.result(template_binding)
      end

      def write_page(filename, title, content)
        layout_path = File.join(TEMPLATES_DIR, "layout.html.erb")
        layout = ERB.new(File.read(layout_path), trim_mode: "-")

        html = layout.result(binding_for_layout(title, content))

        filepath = File.join(output_dir, filename)
        FileUtils.mkdir_p(File.dirname(filepath))
        File.write(filepath, html)
      end

      def binding_for_layout(title, content)
        app_name = RailsDocGenerator.configuration.app_name
        theme_color = RailsDocGenerator.configuration.theme_color
        binding
      end

      def binding_for_index
        controllers = routes
        controllers_count = routes.size
        routes_count = routes.values.sum { |d| d[:routes].size }
        models_count = models.size
        binding
      end

      def binding_for_routes
        routes_count = routes.values.sum { |d| d[:routes].size }
        binding
      end

      def binding_for_controller(controller_name, data)
        routes_list = data[:routes]
        actions = data[:actions]
        routes = routes_list # alias for template
        binding
      end

      def binding_for_model(model)
        binding
      end
    end
  end
end

# String extensions for camelization if not in Rails
unless String.method_defined?(:camelize)
  class String
    def camelize
      split(/[_\/]/).map(&:capitalize).join("::")
    end

    def underscore
      gsub("::", "/")
        .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
        .gsub(/([a-z\d])([A-Z])/, '\1_\2')
        .tr("-", "_")
        .downcase
    end
  end
end
