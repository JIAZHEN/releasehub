class ChangeStringToTextInProjects < ActiveRecord::Migration
  def change
    change_column :projects, :deployment_instruction, :text
    change_column :projects, :rollback_instruction, :text
  end
end
