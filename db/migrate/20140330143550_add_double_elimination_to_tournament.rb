class AddDoubleEliminationToTournament < ActiveRecord::Migration
  def change
    add_column :tournaments, :double_elimination, :integer
  end
end
