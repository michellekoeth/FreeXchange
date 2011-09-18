class AddFreecycgroupToUsers < ActiveRecord::Migration
  def change
    add_column :users, :freecycgroup, :string
  end
end
