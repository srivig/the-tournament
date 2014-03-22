class ChangeDefaultValueToNullOfScore < ActiveRecord::Migration
  def change
    change_column :game_records, :score, :integer, default: nil
  end
end
