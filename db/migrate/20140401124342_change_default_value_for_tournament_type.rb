class ChangeDefaultValueForTournamentType < ActiveRecord::Migration
  def self.up
    change_column :tournaments, :type, :string, default: 'SingleElimination'
  end

  def self.down
    change_column :tournaments, :type, :string, default: nil
  end
end
