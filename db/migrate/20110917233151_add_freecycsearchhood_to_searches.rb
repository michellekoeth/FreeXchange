class AddFreecycsearchhoodToSearches < ActiveRecord::Migration
  def change
    add_column :searches, :freecycsearchhood, :string
  end
end
