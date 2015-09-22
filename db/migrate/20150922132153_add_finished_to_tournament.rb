class AddFinishedToTournament < ActiveRecord::Migration
  def change
    add_column :tournaments, :finished, :boolean, default: false
    add_index :tournaments, :finished
  end
end
