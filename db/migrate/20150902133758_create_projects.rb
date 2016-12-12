class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.integer :deployment_id
      t.integer :branch_id
      t.integer :deployment_order
      t.string :sha
      t.string :deployment_instruction
      t.string :rollback_instruction

      t.timestamps null: false
    end
    add_index :projects, :deployment_id
    add_index :projects, :branch_id
  end
end
