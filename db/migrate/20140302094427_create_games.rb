class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :tournament_id
      t.integer :bracket
      t.integer :round
      t.integer :match
      t.boolean :bye

      t.timestamps
    end
  end
end
