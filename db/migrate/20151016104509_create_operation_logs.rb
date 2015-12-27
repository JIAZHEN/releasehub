class CreateOperationLogs < ActiveRecord::Migration
  def change
    create_table :operation_logs do |t|
      t.string :username
      t.integer :status_id
      t.integer :deployment_id

      t.timestamps null: false
    end
    add_index :operation_logs, :username
    add_index :operation_logs, :status_id
  end
end
