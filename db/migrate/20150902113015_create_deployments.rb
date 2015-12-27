class CreateDeployments < ActiveRecord::Migration
  def change
    create_table :deployments do |t|
      t.integer :release_id
      t.integer :environment_id
      t.integer :status_id
      t.string :qa
      t.string :dev

      t.timestamps null: false
    end
    add_index :deployments, :release_id
    add_index :deployments, :environment_id
    add_index :deployments, :status_id
  end
end
