class AddSkipConsolationRoundToTournaments < ActiveRecord::Migration
  def change
    add_column :tournaments, :consolation_round, :boolean, default: true
  end
end
