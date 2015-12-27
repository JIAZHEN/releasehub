class AddCompositeIndexToDeployments < ActiveRecord::Migration
  def change
    add_index :deployments, [:environment_id, :created_at]
  end
end
