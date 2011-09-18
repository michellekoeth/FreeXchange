class AddPhonenumberToUsers < ActiveRecord::Migration
  def change
    add_column :users, :phonenumber, :string
  end
end
