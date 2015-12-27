class ChangeQaToList < ActiveRecord::Migration
  def change
    rename_column :deployments, :qa, :notification_list
  end
end
