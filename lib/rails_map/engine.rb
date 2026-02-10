# frozen_string_literal: true

module RailsMap
  class Engine < ::Rails::Engine
    isolate_namespace RailsMap

    initializer "rails_map.assets" do |app|
      # No external assets needed - CSS is inline
    end
  end
end
