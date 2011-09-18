class AddFreecycsearchgroupToSearches < ActiveRecord::Migration
  def change
    add_column :searches, :freecycsearchgroup, :string
  end
end
