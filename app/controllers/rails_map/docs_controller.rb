# frozen_string_literal: true

module RailsMap
  class DocsController < ActionController::Base
    layout false
    before_action :load_configuration
    before_action :authenticate_access!

    def index
      @routes = Parsers::RouteParser.new.parse
      @models = Parsers::ModelParser.new.parse
      
      # Debug logging
      Rails.logger.info "RailsMap: Found #{@routes&.size || 0} controllers"
      Rails.logger.info "RailsMap: Found #{@models&.size || 0} models"
      
      # Ensure we always have a hash, never nil
      @routes ||= {}
      @models ||= {}
    rescue => e
      @routes = {}
      @models = {}
      Rails.logger.error "RailsMap Error: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
    end

    def routes
      @routes = Parsers::RouteParser.new.parse
      @routes ||= {}
    rescue => e
      @routes = {}
      Rails.logger.error "RailsMap Error: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
    end

    def controller
      all_routes = Parsers::RouteParser.new.parse || {}
      @controller_name = params[:name]
      @data = all_routes[@controller_name]

      if @data.nil?
        render plain: "Controller not found", status: :not_found
      end
    rescue => e
      render plain: "Error loading controller: #{e.message}", status: :internal_server_error
    end

    def model
      all_models = Parsers::ModelParser.new.parse || {}
      @model_name = params[:name]
      @model = all_models[@model_name]

      if @model.nil?
        render plain: "Model not found", status: :not_found
      end
    rescue => e
      render plain: "Error loading model: #{e.message}", status: :internal_server_error
    end

    private

    def load_configuration
      @config = RailsMap.configuration
    end

    def authenticate_access!
      # Allow host app to define authentication logic
      if @config.authenticate_with.present?
        instance_eval(&@config.authenticate_with)
      end
    end
  end
end
