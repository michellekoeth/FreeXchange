class Standardlistingcols < ActiveRecord::Migration
  def up
    rename_column :listings, :freecycgroup, :group_name
    rename_column :listings, :freecyclistid, :number
    rename_column :listings, :freecychood, :neighborhood
  end

  def down
    rename_column :listings, :group_name, :freecycgroup 
    rename_column :listings, :number, :freecyclistid
    rename_column :listings, :neighborhood, :freecychood
  end
end
