class AddTypeToGames < ActiveRecord::Migration
  def change
    add_column :games, :type, :string, default: 'Winner'
  end
end
