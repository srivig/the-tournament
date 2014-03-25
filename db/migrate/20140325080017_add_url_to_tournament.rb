class AddUrlToTournament < ActiveRecord::Migration
  def change
    add_column :tournaments, :url, :string
  end
end
