# frozen_string_literal: true

module RailsDocGenerator
  module Parsers
    class RouteParser
      RouteInfo = Struct.new(
        :verb, :path, :controller, :action, :name, :constraints, :defaults,
        keyword_init: true
      )

      def parse
        routes = collect_routes
        group_by_controller(routes)
      end

      private

      def collect_routes
        return [] unless defined?(Rails)

        Rails.application.routes.routes.map do |route|
          next if route.internal?

          requirements = route.requirements
          controller = requirements[:controller]
          action = requirements[:action]

          next unless controller && action

          RouteInfo.new(
            verb: extract_verb(route),
            path: extract_path(route),
            controller: controller,
            action: action,
            name: route.name,
            constraints: extract_constraints(route),
            defaults: extract_defaults(route)
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
          {
            routes: controller_routes.sort_by { |r| [r.path, r.verb] },
            actions: controller_routes.map(&:action).uniq.sort
          }
        end.sort.to_h
      end
    end
  end
end
