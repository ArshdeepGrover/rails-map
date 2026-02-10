# frozen_string_literal: true

module RailsMap
  module Parsers
    class ModelParser
      ColumnInfo = Struct.new(
        :name, :type, :default, :null, :limit, :precision, :scale,
        keyword_init: true
      )

      AssociationInfo = Struct.new(
        :name, :type, :class_name, :foreign_key, :options,
        keyword_init: true
      )

      ValidationInfo = Struct.new(
        :attribute, :kind, :options,
        keyword_init: true
      )

      ScopeInfo = Struct.new(
        :name, :arity,
        keyword_init: true
      )

      ModelInfo = Struct.new(
        :name, :table_name, :columns, :associations, :validations, :scopes, :primary_key,
        keyword_init: true
      )

      def parse
        return {} unless defined?(Rails) && defined?(ActiveRecord::Base)

        # Eager load all models - force it even in development
        begin
          Rails.application.eager_load!
        rescue => e
          Rails.logger.warn "Could not eager load: #{e.message}" if defined?(Rails.logger)
        end
        
        # Also try to load app/models directory explicitly
        if defined?(Rails.root)
          Dir[Rails.root.join('app/models/**/*.rb')].each do |file|
            begin
              require_dependency file
            rescue => e
              # Ignore errors, file might already be loaded
            end
          end
        end

        models = ActiveRecord::Base.descendants.reject do |model|
          model.abstract_class? || 
            model.name.nil? || 
            model.name.start_with?("HABTM_") ||
            excluded_model?(model)
        end

        models.each_with_object({}) do |model, hash|
          hash[model.name] = parse_model(model)
        rescue StandardError => e
          # Skip models that can't be introspected
          Rails.logger.warn("Could not parse model #{model.name}: #{e.message}") if defined?(Rails.logger)
        end.sort.to_h
      end

      private

      def parse_model(model)
        ModelInfo.new(
          name: model.name,
          table_name: safe_table_name(model),
          columns: parse_columns(model),
          associations: parse_associations(model),
          validations: parse_validations(model),
          scopes: parse_scopes(model),
          primary_key: safe_primary_key(model)
        )
      end

      def safe_table_name(model)
        model.table_name
      rescue StandardError
        nil
      end

      def safe_primary_key(model)
        model.primary_key
      rescue StandardError
        "id"
      end

      def parse_columns(model)
        return [] unless model.table_exists?

        model.columns.map do |column|
          ColumnInfo.new(
            name: column.name,
            type: column.type.to_s,
            default: column.default,
            null: column.null,
            limit: column.limit,
            precision: column.precision,
            scale: column.scale
          )
        end.sort_by(&:name)
      rescue StandardError
        []
      end

      def parse_associations(model)
        model.reflect_on_all_associations.map do |assoc|
          AssociationInfo.new(
            name: assoc.name.to_s,
            type: assoc.macro.to_s,
            class_name: association_class_name(assoc),
            foreign_key: association_foreign_key(assoc),
            options: extract_association_options(assoc)
          )
        end.sort_by(&:name)
      rescue StandardError
        []
      end

      def association_class_name(assoc)
        assoc.class_name
      rescue StandardError
        assoc.name.to_s.classify
      end

      def association_foreign_key(assoc)
        assoc.foreign_key.to_s
      rescue StandardError
        nil
      end

      def extract_association_options(assoc)
        options = {}
        options[:dependent] = assoc.options[:dependent] if assoc.options[:dependent]
        options[:through] = assoc.options[:through].to_s if assoc.options[:through]
        options[:polymorphic] = true if assoc.options[:polymorphic]
        options[:as] = assoc.options[:as].to_s if assoc.options[:as]
        options
      end

      def parse_validations(model)
        return [] unless RailsMap.configuration.include_validations

        model.validators.flat_map do |validator|
          validator.attributes.map do |attr|
            ValidationInfo.new(
              attribute: attr.to_s,
              kind: validator.kind.to_s,
              options: extract_validation_options(validator)
            )
          end
        end.sort_by { |v| [v.attribute, v.kind] }
      rescue StandardError
        []
      end

      def extract_validation_options(validator)
        validator.options.reject { |k, _| k == :if || k == :unless }
                 .transform_values(&:to_s)
      rescue StandardError
        {}
      end

      def parse_scopes(model)
        return [] unless RailsMap.configuration.include_scopes

        scope_names = model.methods.grep(/^_scope_/).map { |m| m.to_s.sub("_scope_", "") }

        # Alternative: check defined scopes
        if model.respond_to?(:defined_scopes)
          scope_names = model.defined_scopes.keys.map(&:to_s)
        end

        # Fallback: look at singleton methods that return ActiveRecord::Relation
        if scope_names.empty?
          scope_names = extract_scope_names_from_singleton_methods(model)
        end

        scope_names.uniq.sort.map do |name|
          ScopeInfo.new(
            name: name,
            arity: safe_scope_arity(model, name)
          )
        end
      rescue StandardError
        []
      end

      def extract_scope_names_from_singleton_methods(model)
        # This is a heuristic approach
        model.singleton_methods(false).select do |method|
          # Skip common non-scope methods
          !%w[table_name primary_key inheritance_column].include?(method.to_s)
        end.map(&:to_s)
      rescue StandardError
        []
      end

      def safe_scope_arity(model, name)
        model.method(name).arity
      rescue StandardError
        0
      end

      def excluded_model?(model)
        return true if model.name.nil?
        
        # Exclude models from gems/engines by namespace
        excluded_namespaces = %w[
          RailsMap
          ActionMailbox
          ActionText
          ActiveStorage
          Turbo
          Devise
          Sidekiq
          SolidQueue
          SolidCache
          GoodJob
          Que
          Delayed
          Flipper
          PgHero
          Blazer
          Avo
          MissionControl
          Administrate
          RailsAdmin
          Ahoy
        ]
        
        # Check namespace exclusions first (fast check)
        model_name = model.name.to_s
        first_namespace = model_name.split('::').first
        return true if excluded_namespaces.include?(first_namespace)
        return true if excluded_namespaces.any? { |ns| model_name.start_with?("#{ns}::") }
        
        # Check if model file exists in app/models of host app
        if defined?(Rails.root)
          # Convert model name to file path (e.g., User -> user.rb, Admin::User -> admin/user.rb)
          model_path = model_name.underscore + '.rb'
          model_file = Rails.root.join('app', 'models', model_path)
          
          # If the file doesn't exist in app/models, it's likely from a gem
          return true unless File.exist?(model_file)
        end
        
        false
      end
    end
  end
end
