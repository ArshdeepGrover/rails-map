# frozen_string_literal: true

class CreateRailsDocGeneratorUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :rails_doc_generator_users do |t|
      t.string :username, null: false
      t.string :password_digest, null: false
      
      t.timestamps
    end
    
    add_index :rails_doc_generator_users, :username, unique: true
  end
end
