class AddRoleToUsers < ActiveRecord::Migration[6.0]
  def up
    add_column :users, :role, :integer, default: 0
    add_index :users, :role
  end

  def down
    remove_column :users, :role
  end
end
