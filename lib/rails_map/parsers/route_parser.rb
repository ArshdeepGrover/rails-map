# frozen_string_literal: true

module RailsMap
  module Parsers
    class RouteParser
      RouteInfo = Struct.new(
        :verb, :path, :controller, :action, :name, :constraints, :defaults, :base_path,
        :path_params, :query_params, :request_body_params,
        keyword_init: true
      )

      def parse
        routes = collect_routes
        Rails.logger.info "RouteParser: Collected #{routes.size} routes" if defined?(Rails.logger)
        grouped = group_by_controller(routes)
        Rails.logger.info "RouteParser: Grouped into #{grouped.size} controllers" if defined?(Rails.logger)
        grouped
      end

      private

      def collect_routes
        return [] unless defined?(Rails)

        Rails.application.routes.routes.map do |route|
          next if internal_route?(route)

          requirements = route.requirements
          controller = requirements[:controller]
          action = requirements[:action]

          next unless controller && action

          path = extract_path(route)
          path_params = extract_path_params(path)
          
          RouteInfo.new(
            verb: extract_verb(route),
            path: path,
            controller: controller,
            action: action,
            name: route.name,
            constraints: extract_constraints(route),
            defaults: extract_defaults(route),
            base_path: extract_base_path(path),
            path_params: path_params,
            query_params: extract_query_params(controller, action),
            request_body_params: extract_body_params(controller, action)
          )
        end.compact
      end

      def extract_verb(route)
        verb = route.verb
        return verb if verb.is_a?(String)
        return verb.source.gsub(/[$^]/, "") if verb.respond_to?(:source)

        "ANY"
      end

      def extract_path(route)
        path = route.path.spec.to_s
        # Remove format segment if present
        path.gsub("(.:format)", "")
      end

      def extract_path_params(path)
        # Extract parameters from path like :id, :user_id, etc.
        params = []
        path.scan(/:(\w+)/).flatten.each do |param|
          params << {
            name: param,
            type: infer_param_type(param),
            required: true,
            location: 'path'
          }
        end
        params
      end

      def extract_query_params(controller, action)
        # Try to extract query parameters from controller action
        params = []
        begin
          controller_file = find_controller_file(controller)
          return params unless controller_file && File.exist?(controller_file)

          content = File.read(controller_file)
          
          # Look for params.permit or params.require patterns in the action
          action_content = extract_action_content(content, action)
          return params unless action_content

          # Extract permitted parameters
          permitted_params = extract_permitted_params(action_content)
          
          # For GET requests, these are typically query params
          permitted_params.each do |param|
            params << {
              name: param[:name],
              type: param[:type] || 'string',
              required: param[:required] || false,
              location: 'query'
            }
          end
        rescue => e
          Rails.logger.debug "Could not extract query params for #{controller}##{action}: #{e.message}" if defined?(Rails.logger)
        end
        params
      end

      def extract_body_params(controller, action)
        # Try to extract request body parameters from controller action
        params = []
        begin
          controller_file = find_controller_file(controller)
          return params unless controller_file && File.exist?(controller_file)

          content = File.read(controller_file)
          
          # Look for params.permit or params.require patterns in the action
          action_content = extract_action_content(content, action)
          return params unless action_content

          # Extract permitted parameters
          permitted_params = extract_permitted_params(action_content)
          
          # For POST/PUT/PATCH requests, these are typically body params
          permitted_params.each do |param|
            params << {
              name: param[:name],
              type: param[:type] || 'string',
              required: param[:required] || false,
              location: 'body'
            }
          end
        rescue => e
          Rails.logger.debug "Could not extract body params for #{controller}##{action}: #{e.message}" if defined?(Rails.logger)
        end
        params
      end

      def find_controller_file(controller)
        return nil unless defined?(Rails.root)
        Rails.root.join('app', 'controllers', "#{controller}_controller.rb")
      end

      def extract_action_content(content, action)
        # Extract the content of a specific action method
        action_regex = /def\s+#{Regexp.escape(action)}\b.*?(?=\n\s*def\s|\n\s*private\s|\n\s*protected\s|\nend\s*\z)/m
        match = content.match(action_regex)
        match ? match[0] : nil
      end

      def extract_permitted_params(action_content)
        params = []
        
        # Pattern 1: params.require(:model).permit(:attr1, :attr2, ...)
        require_permit_pattern = /params\.require\(:(\w+)\)\.permit\((.*?)\)/m
        if match = action_content.match(require_permit_pattern)
          model_name = match[1]
          permitted_attrs = match[2]
          
          # Extract individual attributes
          permitted_attrs.scan(/:(\w+)/).flatten.each do |attr|
            params << {
              name: "#{model_name}[#{attr}]",
              type: infer_param_type(attr),
              required: true
            }
          end
        end
        
        # Pattern 2: params.permit(:attr1, :attr2, ...)
        permit_pattern = /params\.permit\((.*?)\)/m
        action_content.scan(permit_pattern).flatten.each do |permitted_attrs|
          permitted_attrs.scan(/:(\w+)/).flatten.each do |attr|
            # Avoid duplicates
            unless params.any? { |p| p[:name].include?(attr) }
              params << {
                name: attr,
                type: infer_param_type(attr),
                required: false
              }
            end
          end
        end
        
        # Pattern 3: params[:key] or params['key']
        params_access_pattern = /params\[['"]?:?(\w+)['"]?\]/
        action_content.scan(params_access_pattern).flatten.uniq.each do |attr|
          # Avoid duplicates and common Rails params
          next if %w[controller action format id].include?(attr)
          unless params.any? { |p| p[:name] == attr || p[:name].include?(attr) }
            params << {
              name: attr,
              type: infer_param_type(attr),
              required: false
            }
          end
        end
        
        params.uniq { |p| p[:name] }
      end

      def infer_param_type(param_name)
        # Infer parameter type from name
        case param_name.to_s
        when /_(id|ids)$/
          'integer'
        when /^is_/, /^has_/, /_flag$/, /_enabled$/
          'boolean'
        when /_at$/, /_date$/
          'datetime'
        when /_count$/, /_number$/, /^count_/, /^num_/
          'integer'
        when /_price$/, /_amount$/, /_total$/
          'decimal'
        when /_email$/
          'email'
        when /_url$/
          'url'
        else
          'string'
        end
      end

      def extract_constraints(route)
        constraints = {}
        route.requirements.each do |key, value|
          next if %i[controller action].include?(key)

          constraints[key] = value.is_a?(Regexp) ? value.source : value.to_s
        end
        constraints
      end

      def extract_defaults(route)
        defaults = {}
        route.defaults.each do |key, value|
          next if %i[controller action].include?(key)

          defaults[key] = value.to_s
        end
        defaults
      end

      def group_by_controller(routes)
        grouped = routes.group_by(&:controller)

        grouped.transform_values do |controller_routes|
          sorted_routes = controller_routes.sort_by { |r| [r.path, verb_order(r.verb)] }
          {
            routes: sorted_routes,
            actions: controller_routes.map(&:action).uniq.sort,
            base_path: find_common_base_path(controller_routes)
          }
        end.sort_by { |controller, _| controller.downcase }.to_h
      end

      def extract_base_path(path)
        # Extract first meaningful segment: /users/:id -> /users
        segments = path.split('/').reject(&:empty?)
        return '/' if segments.empty?
        
        # Take first segment that doesn't start with : or *
        base = segments.take_while { |s| !s.start_with?(':', '*') }
        base.empty? ? "/#{segments.first}" : "/#{base.join('/')}"
      end

      def find_common_base_path(routes)
        paths = routes.map(&:base_path).uniq
        return paths.first if paths.size == 1
        
        # Find common prefix
        paths.min_by(&:length) || '/'
      end

      def verb_order(verb)
        # Order: GET, POST, PUT, PATCH, DELETE, others
        order = { 'GET' => 0, 'POST' => 1, 'PUT' => 2, 'PATCH' => 3, 'DELETE' => 4 }
        order[verb.to_s.upcase] || 5
      end

      def internal_route?(route)
        # Rails 7+ uses internal? method
        return true if route.respond_to?(:internal?) && route.internal?
        
        # Rails 6.x uses internal attribute
        return true if route.respond_to?(:internal) && route.internal
        
        # Check if it's a Rails internal route by path
        path = route.path.spec.to_s rescue ''
        return true if path.start_with?('/rails/')
        
        # Check controller namespace - exclude gem/engine controllers
        controller = route.requirements[:controller].to_s
        return true if excluded_controller?(controller)
        
        false
      end

      def excluded_controller?(controller)
        return true if controller.nil? || controller.empty?
        
        controller_downcase = controller.to_s.downcase
        
        # Exclude common gem/internal controller namespaces (check first segment)
        excluded_prefixes = %w[
          rails_map
          action_mailbox
          action_cable
          active_storage
          action_text
          turbo
          devise
          sidekiq
          letter_opener
          better_errors
          web_console
          solid_queue
          solid_cache
          mission_control
          rails
          graphiql
          pghero
          blazer
          flipper
          rswag
          swagger
          avo
          administrate
          rails_admin
          good_job
          que
          delayed
        ]
        
        # Check if controller starts with any excluded prefix
        first_segment = controller_downcase.split('/').first
        return true if excluded_prefixes.include?(first_segment)
        
        # Check prefix match (e.g., "action_mailbox/ingresses/...")
        return true if excluded_prefixes.any? { |prefix| controller_downcase.start_with?("#{prefix}/") }
        
        # Check if controller file exists in app/controllers of host app
        if defined?(Rails.root)
          controller_file = Rails.root.join('app', 'controllers', "#{controller}_controller.rb")
          return true unless File.exist?(controller_file)
        end
        
        false
      end
    end
  end
end
