class AddProfileToUser < ActiveRecord::Migration
  def change
    add_column :users, :name, :string, limit: 255
    add_column :users, :profile, :text
    add_column :users, :url, :string, limit: 255
    add_column :users, :facebook_url, :string, limit: 255
    add_column :users, :profile_img_url, :string, limit: 255
  end
end
