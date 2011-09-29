class Numbercolnowstring < ActiveRecord::Migration
  def up
    change_column :listings, :number, :string
  end

  def down
    change_column :listings, :number, :integer
  end
end
