class AddDeploymentOrderToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :deployment_order, :integer
  end
end
