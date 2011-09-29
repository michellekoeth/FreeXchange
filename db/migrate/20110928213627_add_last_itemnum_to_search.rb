class AddLastItemnumToSearch < ActiveRecord::Migration
  def change
    add_column :searches, :last_itemnum, :string
  end
end
