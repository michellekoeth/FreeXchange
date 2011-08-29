class CreateListings < ActiveRecord::Migration
  def self.up
    create_table :listings do |t|
      t.integer :searchid
      t.string :freecycgroup
      t.string :freecychood
      t.integer :freecyclistid
      t.text :dateposted

      t.timestamps
    end
  end

  def self.down
    drop_table :listings
  end
end
