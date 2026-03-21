# frozen_string_literal: true

class CreateRailsMapUsers < ActiveRecord::Migration[<%= ActiveRecord::Migration.current_version %>]
  def change
    create_table :rails_map_users do |t|
      t.string :username, null: false
      t.string :password_digest, null: false
      
      t.timestamps
    end
    
    add_index :rails_map_users, :username, unique: true
  end
end
