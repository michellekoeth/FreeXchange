class RenameUsersGroup < ActiveRecord::Migration
  def up
    rename_column :users, :freecycgroup, :group_name
  end

  def down
    rename_column :users, :group_name, :freecycgroup
  end
end
