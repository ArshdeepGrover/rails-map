# frozen_string_literal: true

require_relative "rails_map/version"
require_relative "rails_map/configuration"
require_relative "rails_map/auth"
require_relative "rails_map/parsers/route_parser"
require_relative "rails_map/parsers/model_parser"
require_relative "rails_map/generators/html_generator"

module RailsMap
  class Error < StandardError; end

  class << self
    attr_writer :configuration

    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end

    def generate
      Generator.new(configuration).generate
    end
  end

  class Generator
    attr_reader :config

    def initialize(config)
      @config = config
    end

    def generate
      ensure_output_directory

      routes_data = Parsers::RouteParser.new.parse
      models_data = Parsers::ModelParser.new.parse

      generator = Generators::HtmlGenerator.new(
        routes: routes_data,
        models: models_data,
        output_dir: config.output_dir
      )

      generator.generate_all

      puts "Documentation generated successfully in #{config.output_dir}"
    end

    private

    def ensure_output_directory
      FileUtils.mkdir_p(config.output_dir)
      FileUtils.mkdir_p(File.join(config.output_dir, "controllers"))
      FileUtils.mkdir_p(File.join(config.output_dir, "models"))
    end
  end
end

if defined?(Rails::Railtie)
  require_relative "rails_map/engine"
  require_relative "rails_map/railtie"
end
