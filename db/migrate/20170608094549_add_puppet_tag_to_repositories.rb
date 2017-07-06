class AddPuppetTagToRepositories < ActiveRecord::Migration
  def change
    add_column :repositories, :puppet_tag, :string, :after => :name
  end
end
