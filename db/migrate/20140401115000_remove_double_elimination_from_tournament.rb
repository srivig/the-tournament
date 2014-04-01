class RemoveDoubleEliminationFromTournament < ActiveRecord::Migration
  def change
    remove_column :tournaments, :double_elimination, :integer
  end
end
