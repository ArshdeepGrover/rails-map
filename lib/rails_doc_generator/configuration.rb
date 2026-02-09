# frozen_string_literal: true

module RailsDocGenerator
  class Configuration
    attr_accessor :output_dir, :app_name, :include_timestamps, :include_validations,
                  :include_scopes, :theme_color, :authenticate_with

    def initialize
      @output_dir = default_output_dir
      @app_name = default_app_name
      @include_timestamps = true
      @include_validations = true
      @include_scopes = true
      @theme_color = "#3B82F6" # Default blue
    end

    private

    def default_output_dir
      if defined?(Rails)
        Rails.root.join("doc", "api").to_s
      else
        File.join(Dir.pwd, "doc", "api")
      end
    end

    def default_app_name
      if defined?(Rails)
        Rails.application.class.module_parent_name
      else
        "Rails Application"
      end
    end
  end
end
