# frozen_string_literal: true

module RailsDocGenerator
  class Engine < ::Rails::Engine
    isolate_namespace RailsDocGenerator

    initializer "rails_doc_generator.assets" do |app|
      # No external assets needed - CSS is inline
    end
  end
end
