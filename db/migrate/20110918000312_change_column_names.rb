class ChangeColumnNames < ActiveRecord::Migration
  def change
    rename_column :searches, :userid, :user_id
    rename_column :listings, :searchid, :search_id
  end
end
