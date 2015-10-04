class AddPickupToTournament < ActiveRecord::Migration
  def change
    add_column :tournaments, :pickup, :boolean, default: false
    add_index :tournaments, :pickup
  end
end
