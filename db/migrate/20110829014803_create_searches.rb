class CreateSearches < ActiveRecord::Migration
  def self.up
    create_table :searches do |t|
      t.integer :userid
      t.string :querystr
      t.text :datestart
      t.text :dateend

      t.timestamps
    end
  end

  def self.down
    drop_table :searches
  end
end
