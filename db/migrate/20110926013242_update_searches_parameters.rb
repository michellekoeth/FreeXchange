class UpdateSearchesParameters < ActiveRecord::Migration
  def up
    remove_column :searches, :querystr
    remove_column :searches, :datestart
    remove_column :searches, :dateend

    add_column :searches, :search_words, :string

    rename_column :searches, :freecycsearchgroup, :group_name
    rename_column :searches, :freecycsearchhood, :neighborhood
  end

  def down
    add_column :searches, :querystr, :string
    add_column :searches, :datestart, :text
    add_column :searches, :dateend, :text

    remove_column :searches, :search_words

    rename_column :searches, :group_name, :freecycsearchgroup
    rename_column :searches, :neighborhood, :freecycsearchhood
  end
end
