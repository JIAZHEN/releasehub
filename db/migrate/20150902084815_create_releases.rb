class CreateReleases < ActiveRecord::Migration
  def change
    create_table :releases do |t|
      t.string :name
      t.string :summary
      t.integer :status_id

      t.timestamps null: false
    end
    add_index :releases, :name
  end
end
