class AddUserNameToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :user_name, :string, null: false, default: ""
    add_column :users, :is_admin, :boolean, null: false, default: false
  end
end
