class AddScorelessToTournaments < ActiveRecord::Migration
  def change
    add_column :tournaments, :scoreless, :boolean, default: false
  end
end
