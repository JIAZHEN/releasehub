class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :github_login
      t.string :name
      t.string :slack_username
      t.string :remember_token
      t.string :avatar_url

      t.timestamps null: false
    end
    add_index :users, :github_login
    add_index :users, :name
    add_index :users, :remember_token
  end
end
