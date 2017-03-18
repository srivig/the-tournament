class RemoveProfileImgUrlFromUser < ActiveRecord::Migration
  def change
    remove_column :users, :profile_img_url, :string, limit: 255
  end
end
