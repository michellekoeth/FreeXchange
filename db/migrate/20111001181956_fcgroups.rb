class Fcgroups < ActiveRecord::Migration
  def up
     create_table :fcgroups do |t|
      t.string  :group_name
      t.string  :group_name_human
      t.string  :region
      t.string  :state
      t.boolean :nativeToryahooF
      t.boolean :requireaccforviewpost
      t.boolean :requireaccforresppost
      t.string  :groupurl
      t.boolean :systemreg
    end
  end

  def down
    drop_table :fcgroups
  end
end
