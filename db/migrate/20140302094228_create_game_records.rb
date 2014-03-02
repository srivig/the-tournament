class CreateGameRecords < ActiveRecord::Migration
  def change
    create_table :game_records do |t|
      t.integer :game_id
      t.integer :player_id
      t.integer :record_num
      t.integer :score
      t.boolean :winner

      t.timestamps
    end
  end
end
