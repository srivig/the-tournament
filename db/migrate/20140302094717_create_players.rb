class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.integer :tournament_id
      t.integer :seed
      t.string :name
      t.string :group
      t.text :desc

      t.timestamps
    end
  end
end
