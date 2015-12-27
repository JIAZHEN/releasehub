class AddIndexesToTables < ActiveRecord::Migration
  def change
    add_index :releases, :summary
    add_index :releases, :status_id
    add_index :releases, :created_at

    add_index :deployments, :notification_list
    add_index :deployments, :dev
    add_index :deployments, :created_at
  end
end
