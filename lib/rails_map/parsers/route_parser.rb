# frozen_string_literal: true

module RailsMap
  module Parsers
    class RouteParser
      RouteInfo = Struct.new(
        :verb, :path, :controller, :action, :name, :constraints, :defaults, :base_path,
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
          RouteInfo.new(
            verb: extract_verb(route),
            path: path,
            controller: controller,
            action: action,
            name: route.name,
            constraints: extract_constraints(route),
            defaults: extract_defaults(route),
            base_path: extract_base_path(path)
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
