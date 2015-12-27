class CreateBranches < ActiveRecord::Migration
  def change
    create_table :branches do |t|
      t.integer :repository_id
      t.string :name
      t.boolean :active, :default => true

      t.timestamps null: false
    end
  end
end
