class AddFacebookAlbumIdToTournament < ActiveRecord::Migration
  def change
    add_column :tournaments, :facebook_album_id, :string, limit: 255
  end
end
