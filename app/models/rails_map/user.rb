# frozen_string_literal: true

module RailsMap
  class User < ApplicationRecord
    self.table_name = 'rails_map_users'
    
    has_secure_password
    
    validates :username, presence: true, uniqueness: true
    validates :password, length: { minimum: 6 }, if: -> { password.present? }
  end
end
