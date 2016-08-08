class AddIndexes < ActiveRecord::Migration
  def change
    add_index :tournaments, :user_id
    add_index :games, :tournament_id
    add_index :players, :tournament_id
    add_index :game_records, [:game_id, :player_id]
  end
end
