# frozen_string_literal: true

RailsDocGenerator::Engine.routes.draw do
  root to: "docs#index"
  
  get "routes", to: "docs#routes", as: :routes
  get "controllers/*name", to: "docs#controller", as: :controller_doc
  get "models/*name", to: "docs#model", as: :model_doc
end
