class AddSecondaryFinalToTournament < ActiveRecord::Migration
  def change
    add_column :tournaments, :secondary_final, :boolean, default: false
  end
end
